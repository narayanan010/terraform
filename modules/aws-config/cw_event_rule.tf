resource "aws_cloudwatch_event_target" "cross_account_event_bus" {
  count     = var.is_forwarding_to_slack_enabled ? 1 : 0
  target_id = "cross_account_config_event_bus"
  rule      = aws_cloudwatch_event_rule.acer.name
  arn       = var.destination_event_bus_arn
  role_arn  = aws_iam_role.event_bus_invoke_remote_event_bus[0].arn
}

resource "aws_cloudwatch_event_rule" "acer" {
  name        = "cw-event-aws-config"
  description = "Event for AWS Config Rules"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ],
  "detail": {
    "configRuleName": [
      "${aws_config_config_rule.accru.name}",
      "${aws_config_config_rule.accru2.name}",
      "${aws_config_config_rule.accru3.name}",
      "${aws_config_config_rule.check_ec2_detailed_monitoring_enabled.name}",
      "${aws_config_config_rule.check_required_tags.name}"
    ]
  }
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
    resources = [var.destination_event_bus_arn]
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
