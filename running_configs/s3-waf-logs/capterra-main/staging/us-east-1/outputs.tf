output "waf_logs_s3_bucket_name" {
  value       = module.s3_waf_logs.waf_logs_s3_bucket_name
  description = "Name of s3 bucket used for WAF Logs"
}

output "waf_logs_notification_sqs_arn" {
  value       = module.s3_waf_logs.waf_logs_notification_sqs_arn
  description = "ARN of sqs used for notify presence of WAF Logs"
}

output "waf_logs_notification_sqs_url" {
  value       = module.s3_waf_logs.waf_logs_notification_sqs_url
  description = "URL of sqs used for notify presence of WAF Logs"
}

output "scalyr_iam_role_arn" {
  value       = module.s3_waf_logs.scalyr_iam_role_arn
  description = "ARN of iam role used by Scalyr"
}

output "scalyr_monitor" {
  value       = module.s3_waf_logs.scalyr_monitor
  description = "Scalyr monitor to be added in https://app.scalyr.com/monitors"
}
