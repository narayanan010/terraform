resource "aws_cloudwatch_event_target" "cross_account_event_bus" {
  count     = var.is_forwarding_to_slack_enabled ? 1 : 0
  target_id = "cross_account_guardduty_event_bus"
  rule      = aws_cloudwatch_event_rule.guardduty_forward_to_central_account.name
  arn       = local.is_notification_account ?  aws_cloudwatch_event_bus.guardduty_notification[0].arn : local.remote_destination_event_bus
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus[0].arn
}

resource "aws_cloudwatch_event_rule" "guardduty_forward_to_central_account" {
  name        = "guardduty-forward-to-central-account-event-rule"
  description = "Event for AWS Guard Duty Rules"

  event_pattern = <<PATTERN
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


resource "aws_iam_role" "event_bus_invoke_remote_event_bus" {
  count              = var.is_forwarding_to_slack_enabled ? 1 : 0
  name_prefix        = "event-bus-invoke-remote-event-bus"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "event_bus_invoke_remote_event_bus" {
  count = var.is_forwarding_to_slack_enabled ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [local.is_notification_account ?  aws_cloudwatch_event_bus.guardduty_notification[0].arn : local.remote_destination_event_bus]
  }
}

resource "aws_iam_policy" "event_bus_invoke_remote_event_bus" {
  count       = var.is_forwarding_to_slack_enabled ? 1 : 0
  name_prefix = "event_bus_invoke_remote_event_bus"
  policy      = data.aws_iam_policy_document.event_bus_invoke_remote_event_bus[0].json
}

resource "aws_iam_role_policy_attachment" "event_bus_invoke_remote_event_bus" {
  count      = var.is_forwarding_to_slack_enabled ? 1 : 0
  role       = aws_iam_role.event_bus_invoke_remote_event_bus[0].name
  policy_arn = aws_iam_policy.event_bus_invoke_remote_event_bus[0].arn
}