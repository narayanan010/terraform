output "slack_notifier_lambda_arn" {
  value       = aws_lambda_function.config_events_to_slack_notifier.arn
  description = "The ARN of the Slack notifier Lambda"
}

output "config_notification_eventbridge_bus_arn" {
  value       = aws_cloudwatch_event_bus.config_notification.arn
  description = "The ARN of the Eventbridge Bus for Config notification"
}

output "config_notification_eventbridge_rule_arn" {
  value       = aws_cloudwatch_event_rule.match_config_events.arn
  description = "The ARN of the Eventbridge Rule for Config notification"
}

output "slack_channel_webhook_ssm_arn" {
  value       = aws_ssm_parameter.slack_channel_webhook.arn
  description = "The ARN of the SSM parameter for Slack channel webhook"
}
