#BX API Oracle
output "iam_assumable_role_bx_api_oracle" {
  description = "ARN of IAM role for BX Api Oracle"
  value       = module.iam_assumable_role_bx_api_oracle.iam_role_arn
}

output "bx_api_oracle_sa_iam_role_name" {
  description = "Name of IAM role for BX Api Oracle"
  value       = module.iam_assumable_role_bx_api_oracle.iam_role_name
}

output "bx_api_oracle_sa_iam_role_path" {
  description = "Path of IAM role for BX Api Oracle"
  value       = module.iam_assumable_role_bx_api_oracle.iam_role_path
}
