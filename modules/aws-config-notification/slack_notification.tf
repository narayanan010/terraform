data "aws_caller_identity" "current" {}

# Eventbus
resource "aws_cloudwatch_event_bus" "config_notification" {
  name = "config-events"
}

data "aws_iam_policy_document" "config_notification" {
  statement {
    sid    = "SandboxAccountAccess"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "arn:aws:events:${var.region_aws}:${data.aws_caller_identity.current.account_id}:event-bus/${aws_cloudwatch_event_bus.config_notification.name}"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "944864126557", # capterra-sandbox
        "176540105868", # capterra-main
        "377773991577", # capterra-crf-dev
        "350125959894", # capterra-crf-staging
        "738909422062", # capterra-crf-prod
        "148797279579", # capterra-search-dev
        "273213456764", # capterra-search-staging
        "296947561675"  # capterra-search-prod
      ]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "config_notification" {
  policy         = data.aws_iam_policy_document.config_notification.json
  event_bus_name = aws_cloudwatch_event_bus.config_notification.name
}


# Lambda
# This section is for common lambda4 that sends notification to slack compliance channel
resource "aws_lambda_function" "config_events_to_slack_notifier" {
  filename      = "${path.module}/app/config-compliance-to-slack-channel/function.zip"
  function_name = "config-compliance-to-slack-channel-lambda"
  role          = aws_iam_role.config_events_to_slack_notifier.arn
  handler       = "function.handler"

  source_code_hash = filebase64sha256("${path.module}/app/config-compliance-to-slack-channel/function.zip")

  runtime = var.runtime_lambda

  environment {
    variables = {
      WEBHOOK_SSM         = aws_ssm_parameter.slack_channel_webhook.name
      ACCOUNT_MAPPING_SSM = "/capterra/accounts/mapping"
    }
  }
  # depends_on = [data.archive_file.zip_app_slackcompliance]
}
resource "aws_lambda_permission" "config_events_to_slack_notifier" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_events_to_slack_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.match_config_events.arn
}


resource "aws_iam_role" "config_events_to_slack_notifier" {
  name_prefix = "config-events-slack-notifier-lambda-"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )

  inline_policy {
    name = "SSMParametersPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["ssm:GetParameter"]
          Effect = "Allow"
          Resource = [
            aws_ssm_parameter.slack_channel_webhook.arn,
            "arn:aws:ssm:${var.region_aws}:${data.aws_caller_identity.current.account_id}:parameter/capterra/accounts/mapping"]
        },
      ]
    })
  }

}

resource "aws_iam_role_policy_attachment" "slack_notifier_lambda_basic_execution_attachment" {
  role       = aws_iam_role.config_events_to_slack_notifier.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}


# Rule to Target Lambda
#This section configure Cloudwatch events and associates Cloudwatch with Config Rules. In future to add other new AWS Config rules to CW, Append to Below section.
resource "aws_cloudwatch_event_target" "slack_notifier" {
  target_id      = "slack_notifier"
  rule           = aws_cloudwatch_event_rule.match_config_events.name
  arn            = aws_lambda_function.config_events_to_slack_notifier.arn
  event_bus_name = aws_cloudwatch_event_bus.config_notification.name
}

resource "aws_cloudwatch_event_rule" "match_config_events" {
  name           = "aws-config-event"
  description    = "Event for AWS Config Rules"
  event_bus_name = aws_cloudwatch_event_bus.config_notification.name
  event_pattern  = <<PATTERN
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ]
}
PATTERN
}

resource "aws_ssm_parameter" "slack_channel_webhook" {
  name  = "/config/notification/slack-channel-webhook"
  type  = "SecureString"
  value = "placeholder"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
