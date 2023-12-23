output "velero_api_sa_iam_role_arn" {
  description = "ARN of IAM role for velero Api"
  value       = module.iam_assumable_role_velero_api.iam_role_arn
}

output "velero_api_sa_iam_role_name" {
  description = "Name of IAM role for velero Api"
  value       = module.iam_assumable_role_velero_api.iam_role_name
}

output "velero_api_sa_iam_role_path" {
  description = "Path of IAM role for velero Api"
  value       = module.iam_assumable_role_velero_api.iam_role_path
}