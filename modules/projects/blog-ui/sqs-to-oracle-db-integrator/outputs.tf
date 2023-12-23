output "function_name" {
  value       = aws_lambda_function.sqs-to-oracle-db.function_name
  description = "Name of Integration function."
}

output "function_arn" {
  value       = aws_lambda_function.sqs-to-oracle-db.arn
  description = "ARN of Integration function."
}
