output "sqs_id" {
  value       = module.aws_sqs_module.sqs_id
  description = "The URL for the created Amazon SQS queue."
}

output "sqs_arn" {
  value       = module.aws_sqs_module.sqs_arn
  description = "The ARN of the SQS queue"
}