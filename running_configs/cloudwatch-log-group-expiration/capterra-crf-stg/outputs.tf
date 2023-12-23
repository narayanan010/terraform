output "iam_role_arn" {
  value       = module.cloudwatch-log-expiration_module.iam_role_arn
  description = "The Amazon Resource Name (ARN) of the IAM Role created for lambda-cloudwatch association"
}

output "lambda_arn" {
  value       = module.cloudwatch-log-expiration_module.lambda_arn
  description = "ARN of Lambda function created"
}