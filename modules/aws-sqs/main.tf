# This module should:
## Create SQS
## Create KMS Key
## Access Policy for queue

#*************************************************************************************************************************************************************#
#                                                                       DATA SOURCE                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {
}

#*************************************************************************************************************************************************************#
#                                                                         Locals                                                                              #
#*************************************************************************************************************************************************************#

locals {
  dlq_req       = var.dlq_required
  dlq_alert_req = var.dlq_alert_required
}

#*************************************************************************************************************************************************************#
#                                                      			                KMS Key	                                                                              #
#*************************************************************************************************************************************************************#

resource "aws_kms_key" "kms_key_aws" {
  provider                        = aws.awscaller_account
  count                           = var.kms_key_req ? 1 : 0
  description                     = "KMS Key for DocumentDB cluster"
  key_usage                       = "ENCRYPT_DECRYPT"
  is_enabled                      = true
  enable_key_rotation             = true
  customer_master_key_spec        = "SYMMETRIC_DEFAULT"
  policy                          =  <<-EOT

                              {

                                "Version": "2012-10-17",
	                              "Id": "sqs_key_policy",
	                              "Statement": [{
	                              	"Sid": "Enable IAM User Permissions for SQS",
	                              	"Effect": "Allow",
	                              	"Principal": {
	                              		"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
	                              	},
	                              	"Action": [
	                              		"kms:Create*",
                                    "kms:Describe*",
                                    "kms:Enable*",
                                    "kms:List*",
                                    "kms:Put*",
                                    "kms:Update*",
                                    "kms:Revoke*",
                                    "kms:Disable*",
                                    "kms:Get*",
                                    "kms:Delete*",
                                    "kms:ScheduleKeyDeletion",
                                    "kms:CancelKeyDeletion",
                                    "kms:TagResource",
                                    "kms:untagResource"
                                    
	                              	],
	                              	"Resource": "*"
	                              }]
                              }
                                EOT
}


#*************************************************************************************************************************************************************#
#                                                      			                SQS	                                                                              #
#*************************************************************************************************************************************************************#

resource "aws_sqs_queue" "terraform_queue" {
  provider                      = aws.awscaller_account
  name                          = var.fifo_queue ? "${var.queue_name}.fifo" : "${var.queue_name}"
  visibility_timeout_seconds    = var.visibility_timeout
  delay_seconds                 = var.delay_seconds
  max_message_size              = var.max_message_size
  message_retention_seconds     = var.message_retention_seconds
  receive_wait_time_seconds     = var.receive_wait_time_seconds
  #sqs_managed_sse_enabled       = var.sqs_managed_sse_enabled
  fifo_queue                    = var.fifo_queue
  content_based_deduplication   = var.content_duplication
  deduplication_scope           = var.fifo_queue ? var.duplication_scope : null
  fifo_throughput_limit         = var.fifo_queue ? var.fifo_limit : null
  kms_master_key_id             = var.kms_key_arn == null ? aws_kms_key.kms_key_aws[0].key_id : var.kms_key_arn

  redrive_policy                = local.dlq_req ? jsonencode({
    deadLetterTargetArn         = local.dlq_alert_req ? aws_sqs_queue.terraform_queue_alert_deadletter[0].arn : aws_sqs_queue.terraform_queue_deadletter[0].arn
    maxReceiveCount             = var.maxReceiveCount
  }) : null
  
  redrive_allow_policy          = local.dlq_req ? jsonencode({
    redrivePermission           = var.redrivePermission
    #sourceQueueArns             = var.redrivePermission == "byQueue" ? var.source_queues : null
  }) : null 

}

resource "aws_sqs_queue_policy" "logs_notification" {
  provider                      = aws.awscaller_account
  queue_url                 = aws_sqs_queue.terraform_queue.id
  policy                    = data.aws_iam_policy_document.sqs-access.json
}

data "aws_iam_policy_document" "sqs-access" {
  statement {
    sid = "SendMessage"

    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sqs_queue.terraform_queue.arn
    ]
  }
  statement {
    sid = "ReceiveMessage"

    actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
        ]

    principals {
      type        = "AWS"
      identifiers = var.role_name_sqs
    }

    resources = [
      aws_sqs_queue.terraform_queue.arn
    ]
  }
}

resource "aws_sqs_queue" "terraform_queue_deadletter" {
  count = local.dlq_req ? 1 : 0
  provider = aws.awscaller_account
  name = var.fifo_queue ? "${var.queue_name}-dlq.fifo" : "${var.queue_name}-dlq"
  fifo_queue = var.fifo_queue
}

resource "aws_sqs_queue" "terraform_queue_alert_deadletter" {
  count = local.dlq_req && local.dlq_alert_req ? 1 : 0
  provider = aws.awscaller_account
  name = var.fifo_queue ? "${var.queue_name}-alert-dlq.fifo" : "${var.queue_name}-alert-dlq"
  fifo_queue = var.fifo_queue

  redrive_policy                = jsonencode({
    deadLetterTargetArn         = aws_sqs_queue.terraform_queue_deadletter[0].arn
    maxReceiveCount             = 1
  })

  redrive_allow_policy          = jsonencode({
    redrivePermission           = var.redrivePermission
  })
}

resource "aws_sqs_queue_policy" "alert_notification" {
  provider                  = aws.awscaller_account
  count                     = local.dlq_req && local.dlq_alert_req ? 1 : 0
  queue_url                 = aws_sqs_queue.terraform_queue_alert_deadletter[0].id
  policy                    = data.aws_iam_policy_document.sqs-access.json
}

resource "aws_lambda_event_source_mapping" "to_slack_alert" {
  provider         = aws.awscaller_account
  count            = local.dlq_req && local.dlq_alert_req ? 1 : 0
  event_source_arn = aws_sqs_queue.terraform_queue_alert_deadletter[0].arn
  function_name    = aws_lambda_function.slack_alert[0].arn
}

resource "aws_lambda_function" "slack_alert" {
  provider      = aws.awscaller_account
  count         = local.dlq_req && local.dlq_alert_req ? 1 : 0
  filename      = data.archive_file.slack_alert_lambda_code[0].output_path
  function_name = "${var.vertical}-${var.application}-${var.environment}-slack-alert"
  role          = aws_iam_role.slack_alert_lambda[0].arn
  handler       = "function.handler"

  source_code_hash = data.archive_file.slack_alert_lambda_code[0].output_base64sha256

  runtime       = "python3.9"

  environment {
    variables = {
      WEBHOOK_SSM = var.slack_alert_webhook_parameter,
      APPLICATION = var.application,
      ENVIRONMENT = var.environment,
      QUEUE_URL = aws_sqs_queue.terraform_queue_deadletter[0].id
    }
  }

  layers = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:21"]
}

resource "aws_iam_role" "slack_alert_lambda" {
  count              = local.dlq_req && local.dlq_alert_req ? 1 : 0
  provider           = aws.awscaller_account
  name               = "${var.vertical}-${var.application}-${var.environment}-slack-alert-lambda"
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
    policy = data.aws_iam_policy_document.lambda_access[0].json
  }
}

data "aws_iam_policy_document" "lambda_access" {
  count = local.dlq_req && local.dlq_alert_req ? 1 : 0
  statement {
    sid = "SQSReceive"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      aws_sqs_queue.terraform_queue_alert_deadletter[0].arn,
    ]
  }
  statement {
    sid = "SQSSend"

    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      aws_sqs_queue.terraform_queue_deadletter[0].arn,
    ]
  }
  statement {
    sid = "SSM"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter${var.slack_alert_webhook_parameter}",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "slack_alert_lambda_basic_execution" {
  count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
  role        = aws_iam_role.slack_alert_lambda[0].name
  policy_arn  = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "slack_alert_lambda_insights_policy" {
  provider    = aws.awscaller_account
  count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
  role        = aws_iam_role.slack_alert_lambda[0].id
  policy_arn  = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "null_resource" "slack_alert_lambda_code_build" {
  count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
  triggers    = {
    sha256    = filebase64sha256("${path.module}/app/slack-alert/requirements.txt")
  }

  provisioner "local-exec" {
    command   = "cd ${path.module}/app/slack-alert && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
  }
}

data "archive_file" "slack_alert_lambda_code" {
  count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/app/slack-alert"
  output_path = "${path.module}/function.zip"
  depends_on  = [null_resource.slack_alert_lambda_code_build[0]]
}
