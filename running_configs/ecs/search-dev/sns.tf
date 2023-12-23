locals {
  topic_name   = "${var.tag_application}_asg"
  service_name = "${var.tag_application}_Sns2Slack"
  runtime_dir  = "${path.module}/source"
}

resource "aws_autoscaling_notification" "asg_notify" {
  group_names = [
    aws_autoscaling_group.autoscaling_group.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.sns_topic_ags.arn
}

resource "aws_sns_topic" "sns_topic_ags" {
  name = local.topic_name
}

resource "aws_sns_topic_subscription" "sns_topic_lambda" {
  topic_arn = aws_sns_topic.sns_topic_ags.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_lambda.arn
}

resource "null_resource" "build_runtime" {
  triggers = {
    sha256 = filebase64sha256("${local.runtime_dir}/function.py")
  }

  provisioner "local-exec" {
    command = "cd ${local.runtime_dir} && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
  }
}

data "archive_file" "sns_lambda" {
  type             = "zip"
  source_dir       = local.runtime_dir
  output_path      = "${local.runtime_dir}/function.zip"
  output_file_mode = "0666"

  depends_on = [null_resource.build_runtime]
}

resource "aws_lambda_function" "sns_lambda" {
  function_name    = local.service_name
  filename         = data.archive_file.sns_lambda.output_path
  role             = aws_iam_role.sns_role.arn
  handler          = "function.handler"
  description      = "Lambda for SNS Slack integration"
  source_code_hash = data.archive_file.sns_lambda.output_base64sha256

  runtime       = "python3.10"
  memory_size   = 128
  timeout       = 30
  architectures = ["arm64"]

  ephemeral_storage {
    size = 512
  }

  environment {
    variables = {
      SLACK_CHANNEL_ID = "C033H6Q3F9T" # test-alerts
      #SLACK_CHANNEL_ID = "C05NVJVB3RT" # bx-buyer-activation-notifications
      SLACK_SUBJECT = "AWS Autoscaling Notification"
      SLACK_TOKEN   = aws_ssm_parameter.slack_notify_token.name
    }
  }

  depends_on = [data.archive_file.sns_lambda, aws_iam_role.sns_role]
}

resource "aws_lambda_permission" "sns_topic" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sns_topic_ags.arn
}

resource "aws_ssm_parameter" "slack_notify_token" {
  name        = "/devops/slack_webhooks/user-workspace"
  description = "Slack Bot User OAuth Token for user-workspace"
  type        = "SecureString"
  value       = "dummy"

  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}