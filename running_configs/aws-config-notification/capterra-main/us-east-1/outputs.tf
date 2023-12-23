output "slack_notifier_lambda_arn" {
  value       = module.aws-config-notification.slack_notifier_lambda_arn
  description = "The ARN of the Slack notifier Lambda"
}

output "config_notification_eventbridge_bus_arn" {
  value       = module.aws-config-notification.config_notification_eventbridge_bus_arn
  description = "The ARN of the Eventbridge Bus for Config notification"
}

output "config_notification_eventbridge_rule_arn" {
  value       = module.aws-config-notification.config_notification_eventbridge_rule_arn
  description = "The ARN of the Eventbridge Rule for Config notification"
}

output "slack_channel_webhook_ssm_arn" {
  value       = module.aws-config-notification.slack_channel_webhook_ssm_arn
  description = "The ARN of the SSM parameter for Slack channel webhook"
}
