# resource "aws_lambda_event_source_mapping" "to_slack_alert" {
#   count            = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   event_source_arn = aws_sqs_queue.terraform_queue_alert_deadletter[0].arn
#   function_name    = aws_lambda_function.slack_alert[0].arn
# }

# resource "aws_lambda_function" "slack_alert" {
#   count         = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   filename      = data.archive_file.slack_alert_lambda_code[0].output_path
#   function_name = "${var.vertical}-${var.application}-${var.environment}-slack-alert"
#   role          = aws_iam_role.slack_alert_lambda[0].arn
#   handler       = "function.handler"

#   source_code_hash = data.archive_file.slack_alert_lambda_code[0].output_base64sha256

#   runtime       = "python3.9"

#   environment {
#     variables = {
#       WEBHOOK_SSM = var.slack_alert_webhook_parameter,
#       APPLICATION = var.application,
#       ENVIRONMENT = var.environment,
#       QUEUE_URL = aws_sqs_queue.terraform_queue_deadletter[0].id
#     }
#   }

#   layers = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:21"]
# }

# resource "aws_iam_role" "slack_alert_lambda" {
#   count              = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   name               = "${var.vertical}-${var.application}-${var.environment}-slack-alert-lambda"
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY

#   inline_policy {
#     name   = "lambda_access_policy"
#     policy = data.aws_iam_policy_document.lambda_access[0].json
#   }
# }

# data "aws_iam_policy_document" "lambda_access" {
#   count = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   statement {
#     sid = "SQSReceive"

#     actions = [
#       "sqs:ReceiveMessage",
#       "sqs:DeleteMessage",
#       "sqs:GetQueueAttributes",
#     ]

#     resources = [
#       aws_sqs_queue.terraform_queue_alert_deadletter[0].arn,
#     ]
#   }
#   statement {
#     sid = "SQSSend"

#     actions = [
#       "sqs:SendMessage",
#       "sqs:GetQueueAttributes",
#     ]

#     resources = [
#       aws_sqs_queue.terraform_queue_deadletter[0].arn,
#     ]
#   }
#   statement {
#     sid = "SSM"

#     actions = [
#       "ssm:GetParameter",
#     ]

#     resources = [
#       "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter${var.slack_alert_webhook_parameter}",
#     ]
#   }
# }

# resource "aws_iam_role_policy_attachment" "slack_alert_lambda_basic_execution" {
#   count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   role        = aws_iam_role.slack_alert_lambda[0].name
#   policy_arn  = "arn:aws:iam::aws:policy/AWSLambdaExecute"
# }

# resource "aws_iam_role_policy_attachment" "slack_alert_lambda_insights_policy" {
#   count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   role        = aws_iam_role.slack_alert_lambda[0].id
#   policy_arn  = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
# }

# resource "null_resource" "slack_alert_lambda_code_build" {
#   count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   triggers    = {
#     sha256    = filebase64sha256("${path.module}/app/slack-alert/requirements.txt")
#   }

#   provisioner "local-exec" {
#     command   = "cd ${path.module}/app/slack-alert && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
#   }
# }

# data "archive_file" "slack_alert_lambda_code" {
#   count       = local.dlq_req && local.dlq_alert_req ? 1 : 0
#   type        = "zip"
#   source_dir  = "${path.module}/app/slack-alert"
#   output_path = "${path.module}/function.zip"
#   depends_on  = [null_resource.slack_alert_lambda_code_build[0]]
# }