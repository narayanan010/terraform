output "sqs_id" {
  value       = aws_sqs_queue.terraform_queue.id
  description = "The URL for the created Amazon SQS queue."
}

output "sqs_arn" {
  value       = aws_sqs_queue.terraform_queue.arn
  description = "The ARN of the SQS queue"
}

output "sqs_name" {
  value       = aws_sqs_queue.terraform_queue.name
  description = "The Name for the created Amazon SQS queue."
}
