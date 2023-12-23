output "iam_role_arn" {
  value       = aws_iam_role.tf-lambda_CloudWatchLogs_Role.arn
  description = "The Amazon Resource Name (ARN) of the IAM Role created for lambda-cloudwatch association"
}

output "lambda_arn" {
  value       = aws_lambda_function.lambda_cw_log_group.arn
  description = "ARN of Lambda function created"
}

output "lambda_retencion_policy_exclusions" {
  value       = concat([aws_cloudwatch_log_group.tf-cloudwatch_log_group.name],[var.cw_loggroups_excluded])
  description = "CloudWatch log groups excluded from retention policy"
}
