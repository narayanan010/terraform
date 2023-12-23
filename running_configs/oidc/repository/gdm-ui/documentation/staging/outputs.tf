output "role_github_role_arn" {
  description = "Role github-actions arn for documentation staging"
  value       = aws_iam_role.github_actions_documentation.arn
}
