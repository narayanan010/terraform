#cronjob
output "sa_iam_role_arn" {
  description = "ARN of IAM role for pods"
  value       = module.iam_assumable_role.iam_role_arn
}

output "sa_iam_role_name" {
  description = "Name of IAM role for pods"
  value       = module.iam_assumable_role.iam_role_name
}

output "sa_iam_role_path" {
  description = "Path of IAM role for pods"
  value       = module.iam_assumable_role.iam_role_path
}
