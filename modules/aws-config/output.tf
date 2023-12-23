output "config_rule_id" {
  value       = aws_config_config_rule.accru.rule_id
  description = "The ID of AWS Config Rule"
}

output "config_recorder_id" {
  value       = !var.is_config_managed_by_ccoe ? aws_config_configuration_recorder.accre[0].id : null
  description = "Name of AWS Config recorder"
}

output "s3_bucket_name" {
  value       = !var.is_config_bucket_managed_by_ccoe ? aws_s3_bucket.as3b[0].id : null
  description = "Name of s3 bucket used for AWS Config"
}
