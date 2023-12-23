output "sa_iam_role_arn" {
   description = "ARN of IAM role"
   value       = module.iam_assumable_role_admin.iam_role_arn
 }

 output "sa_iam_role_name" {
   description = "Name of IAM role"
   value       = module.iam_assumable_role_admin.iam_role_name
 }

 output "sa_iam_role_path" {
   description = "Path of IAM role"
   value       = module.iam_assumable_role_admin.iam_role_path
 }

 output "sqs_id" {
  value       = module.aws_sqs_module.sqs_id
  description = "The URL for the created Amazon SQS queue."
}

output "sqs_arn" {
  value       = module.aws_sqs_module.sqs_arn
  description = "The ARN of the SQS queue"
}

output "sqs_name" {
  value       = module.aws_sqs_module.sqs_name
  description = "The Name for the created Amazon SQS queue."
}
