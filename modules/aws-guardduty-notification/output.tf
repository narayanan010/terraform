output "slack_notifier_lambda_arn" {
  value       = local.is_notification_account ? aws_lambda_function.guardduty_events_to_slack_notifier[0].arn : ""
  description = "The ARN of the Slack notifier Lambda"
}

output "guardduty_notification_eventbridge_bus_arn" {
  value       = local.is_notification_account ? aws_cloudwatch_event_bus.guardduty_notification[0].arn : ""
  description = "The ARN of the Eventbridge Bus for guardduty notification"
}

output "guardduty_notification_eventbridge_rule_arn" {
  value       = local.is_notification_account ? aws_cloudwatch_event_rule.match_guardduty_events[0].arn : ""
  description = "The ARN of the Eventbridge Rule for guardduty notification"
}

output "slack_channel_webhook_ssm_arn" {
  value       = local.is_notification_account ? aws_ssm_parameter.slack_channel_webhook[0].arn : ""
  description = "The ARN of the SSM parameter for Slack channel webhook"
}
