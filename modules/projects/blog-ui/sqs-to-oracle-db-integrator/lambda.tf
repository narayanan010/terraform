data "aws_caller_identity" "current" {}

#This section is for IAM role specification to have bare minimum roles to run Rules properly
resource "aws_iam_role" "sqs-to-oracle-db" {
  provider   = aws.awscaller_account
  name        = "${var.vertical}-${var.application}-sqs-to-oracle-db-${var.environment}-lambda"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  inline_policy {
    name   = "lambda_access_policy"
    policy = data.aws_iam_policy_document.lambda-access.json
  }

  inline_policy {
    name   = "dynamoDB_access_policy"
    policy = data.aws_iam_policy_document.dynamoDB-access.json
  }
}

data "aws_iam_policy_document" "lambda-access" {
  statement {
    sid = "SQS"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      var.sqs_arn,
    ]
  }
  statement {
    sid = "SSM"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter${var.db_password_parameter}",
    ]
  }
}

data "aws_iam_policy_document" "dynamoDB-access" {
  statement {
    sid = "DynamoDB"

    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables",
      "dynamodb:GetItem",
    ]

    resources = [
      "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.dynamoDB_table_name}",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "sqs-to-oracle-db-basic-lambda-execution" {
  provider   = aws.awscaller_account
  role       = aws_iam_role.sqs-to-oracle-db.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "sqs-to-oracle-db-vpc-lambda-execution" {
  provider   = aws.awscaller_account
  role       = aws_iam_role.sqs-to-oracle-db.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "insights_policy" {
  provider   = aws.awscaller_account
  role       = aws_iam_role.sqs-to-oracle-db.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

# resource "null_resource" "build" {
#   triggers = {
#     sha256 = filebase64sha256("${path.module}/app/sqs-to-oracle-db/requirements.txt")
#   }

#   provisioner "local-exec" {
#     command     = "cd ${path.module}/app/sqs-to-oracle-db && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
#   }
# }

# data "archive_file" "sqs-to-oracle-db-code" {
#   type        = "zip"
#   source_dir = "${path.module}/app/sqs-to-oracle-db"
#   output_path = "${path.module}/function.zip"
#   # excludes = ["${path.module}/app/sqs-to-oracle-db/*-info", "${path.module}/app/sqs-to-oracle-db/venv", "${path.module}/app/sqs-to-oracle-db/.idea"]
#   depends_on = [null_resource.build]
# }

# This section is for lambda
resource "aws_lambda_function" "sqs-to-oracle-db" {
  provider   = aws.awscaller_account
  # filename      = data.archive_file.sqs-to-oracle-db-code.output_path
  filename      = "${path.module}/empty_lambda_function_payload.zip"
  function_name = "${var.vertical}-${var.application}-sqs-to-oracle-db-${var.environment}-integrator"
  role          = aws_iam_role.sqs-to-oracle-db.arn
  handler       = "function.lambda_handler"

  # source_code_hash = data.archive_file.sqs-to-oracle-db-code.output_base64sha256
  source_code_hash = filebase64sha256("${path.module}/empty_lambda_function_payload.zip")

  runtime = var.runtime_lambda
  memory_size = var.memory_size
  timeout = var.timeout

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = var.subnets_for_lambda
    security_group_ids = [aws_security_group.sqs-to-oracle-db.id]
  }

  environment {
    variables = {
      QUEUE_URL = var.sqs_id,
      DB_USER = var.db_user,
      DB_SERVICE = var.db_service,
      DB_HOST = var.db_host,
      DB_PORT = var.db_port,
      DB_STORED_PROCEDURE = var.db_stored_procedure,
      DB_PASSWORD_PARAMETER = var.db_password_parameter,
      LD_LIBRARY_PATH = "/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib:/opt/python"
    }
  }

  layers = [data.aws_lambda_layer_version.cx_oracle.arn]
  # layers = [data.aws_lambda_layer_version.cx_oracle.arn, "arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:21"]

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      environment
    ]
  }
}

data "aws_lambda_layer_version" "cx_oracle" {
 provider   = aws.awscaller_account 
 layer_name = var.cx_oracle_layer_name
}

resource "aws_lambda_event_source_mapping" "sqs-to-oracle-db" {
  provider   = aws.awscaller_account
  count            = var.is_trigger_enabled ? 1 : 0
  event_source_arn = var.sqs_arn
  function_name    = aws_lambda_function.sqs-to-oracle-db.arn
}

resource "aws_security_group" "sqs-to-oracle-db" {
  provider   = aws.awscaller_account
  name = "${var.vertical}-${var.application}-sqs-to-oracle-db-${var.environment}-lambda-sg"
  description = "Allow ${var.vertical}-${var.application}-sqs-to-oracle-db-${var.environment}-lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
