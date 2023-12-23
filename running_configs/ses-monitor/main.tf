# Docker image 
# ECR Repository
resource "aws_ecr_repository" "ses-bounce-recorder" {
  image_tag_mutability = "MUTABLE"
  name                 = "ses-bounce-recorder"

  image_scanning_configuration {
    scan_on_push = false
  }
}


locals {
  clean_domain = replace(var.ses_domain, ".", "-")
  tag          = formatdate("YYYYMMDD'T'hhmm", timestamp())
}


resource "docker_image" "ses-bounce-recorder" {
  name = "ses-bounce-recorder"
  build {
    path = "ses-bounce-recorder"
    tag = [
      "${aws_ecr_repository.ses-bounce-recorder.repository_url}:${local.tag}"
    ]
    build_arg = {}
    label = {
      author : "devops@capterra.com"
    }
  }
}

data "aws_ecr_authorization_token" "token" {}

resource "null_resource" "login" {
  triggers = {
    tag = local.tag
  }
  depends_on = [docker_image.ses-bounce-recorder]
  provisioner "local-exec" {
    command = "docker login ${aws_ecr_repository.ses-bounce-recorder.repository_url} -u AWS -p ${data.aws_ecr_authorization_token.token.password}"
  }
}


resource "null_resource" "push" {
  triggers = {
    tag = local.tag
  }
  depends_on = [null_resource.login, docker_image.ses-bounce-recorder]
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ses-bounce-recorder.repository_url}:${local.tag}"
  }
}

resource "aws_iam_policy" "lambda-ses-bounce-table-policy" {
  name_prefix = "lambda-ses-bounce-recorder"
  # path        = "/"
  description = "Permissions for DDB bounce monitor lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
        ]
        Resource = [
          aws_dynamodb_table.bounce_table.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ses_bounce_lambda" {
  name = "ses_bounce_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    aws_iam_policy.lambda-ses-bounce-table-policy.arn
  ]
}

resource "aws_kms_key" "sns-bounce-key" {
  description = "KMS key to permit AWS use of SNS encrypted topic"
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowSESToUseKMSKey"
        Effect = "Allow"
        Principal = {
          "Service" = "ses.amazonaws.com"
        }
        Action: [ "kms:GenerateDataKey", "kms:Decrypt" ],
        Resource: "*"
      },
      {
        Sid = "AllowSelfManaged"
        Effect = "Allow"
        Principal = {
          "AWS" = split(":", var.modulecaller_assume_role_primary_account)[4]
        }
        Action: [ "kms:*"]
        Resource: "*"
      }
    ]
  })
}

resource "aws_sns_topic" "ses_bounce" {
  name_prefix       = "ses-bounce-${local.clean_domain}"
  kms_master_key_id = aws_kms_key.sns-bounce-key.key_id
}

resource "aws_ses_identity_notification_topic" "ses-notification" {
  topic_arn                = aws_sns_topic.ses_bounce.arn
  notification_type        = "Bounce"
  identity                 = var.ses_domain
  include_original_headers = true
}

resource "aws_dynamodb_table" "bounce_table" {
  name         = "ses-record-${var.ses_domain}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "MessageId"
  attribute {
    name = "MessageId"
    type = "S"
  }
  ttl {
    enabled        = true
    attribute_name = "ExpireAfter"
  }
}

resource "aws_lambda_function" "on_bounce" {
  depends_on    = [null_resource.push]
  function_name = "ses-bounce-recorder"
  image_uri     = "${aws_ecr_repository.ses-bounce-recorder.repository_url}:${local.tag}"
  package_type  = "Image"
  role          = aws_iam_role.ses_bounce_lambda.arn

  environment {
    variables = {
      DDB_TABLE_NAME = aws_dynamodb_table.bounce_table.name
      TTL_DURATION   = "168h"
    }
  }
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.on_bounce.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ses_bounce.arn
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.ses_bounce.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.on_bounce.arn
}
