output "role_github_bx_api_oracle_role_arn" {
  description = "Role github-actions arn for BX Api Oracle staging"
  value       = aws_iam_role.github_actions_bx_api_oracle.arn
}
