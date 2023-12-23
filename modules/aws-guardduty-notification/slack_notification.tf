# Eventbus
resource "aws_cloudwatch_event_bus" "guardduty_notification" {
  count = local.is_notification_account ? 1 : 0
  name = "guardduty-events"
}

data "aws_iam_policy_document" "guardduty_notification" {
  count = local.is_notification_account ? 1 : 0
  statement {
    sid    = "AccountAccess"
    effect = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "arn:aws:events:${var.region_aws}:${data.aws_caller_identity.current.account_id}:event-bus/${aws_cloudwatch_event_bus.guardduty_notification[0].name}"
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

resource "aws_cloudwatch_event_bus_policy" "guardduty_notification" {
  count = local.is_notification_account ? 1 : 0
  policy         = data.aws_iam_policy_document.guardduty_notification[0].json
  event_bus_name = aws_cloudwatch_event_bus.guardduty_notification[0].name
}


# Lambda
# This section is for common lambda4 that sends notification to slack compliance channel
resource "aws_lambda_function" "guardduty_events_to_slack_notifier" {
  count = local.is_notification_account ? 1 : 0
  filename      = "${path.module}/app/guardduty-compliance-to-slack-channel/function.zip"
  function_name = "guardduty-compliance-to-slack-channel-lambda"
  role          = aws_iam_role.guardduty_events_to_slack_notifier[0].arn
  handler       = "function.handler"

  source_code_hash = filebase64sha256("${path.module}/app/guardduty-compliance-to-slack-channel/function.zip")

  runtime = var.runtime_lambda

  environment {
    variables = {
      WEBHOOK_SSM         = aws_ssm_parameter.slack_channel_webhook[0].name
      ACCOUNT_MAPPING_SSM = "/capterra/accounts/mapping"
    }
  }
}
resource "aws_lambda_permission" "guardduty_events_to_slack_notifier" {
  count = local.is_notification_account ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_events_to_slack_notifier[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.match_guardduty_events[0].arn
}


resource "aws_iam_role" "guardduty_events_to_slack_notifier" {
  count = local.is_notification_account ? 1 : 0
  name_prefix = "guardduty-events-slack-notifier-"

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
            aws_ssm_parameter.slack_channel_webhook[0].arn,
            "arn:aws:ssm:${var.region_aws}:${data.aws_caller_identity.current.account_id}:parameter/capterra/accounts/mapping"]
        },
      ]
    })
  }

}

resource "aws_iam_role_policy_attachment" "slack_notifier_lambda_basic_execution_attachment" {
  count = local.is_notification_account ? 1 : 0
  role       = aws_iam_role.guardduty_events_to_slack_notifier[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}


# Rule to Target Lambda
#This section guarddutyure Cloudwatch events and associates Cloudwatch with guardduty Rules. In future to add other new AWS guardduty rules to CW, Append to Below section.
resource "aws_cloudwatch_event_target" "slack_notifier" {
  count = local.is_notification_account ? 1 : 0
  target_id      = "slack_notifier"
  rule           = aws_cloudwatch_event_rule.match_guardduty_events[0].name
  arn            = aws_lambda_function.guardduty_events_to_slack_notifier[0].arn
  event_bus_name = aws_cloudwatch_event_bus.guardduty_notification[0].name
}

resource "aws_cloudwatch_event_rule" "match_guardduty_events" {
  count = local.is_notification_account ? 1 : 0
  name           = "aws-guardduty-event"
  description    = "Event for AWS guardduty Rules"
  event_bus_name = aws_cloudwatch_event_bus.guardduty_notification[0].name
  event_pattern  = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ]
}
PATTERN
}

resource "aws_ssm_parameter" "slack_channel_webhook" {
  count = local.is_notification_account ? 1 : 0
  name  = "/guardduty/notification/slack-channel-webhook"
  type  = "SecureString"
  value = "placeholder"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}