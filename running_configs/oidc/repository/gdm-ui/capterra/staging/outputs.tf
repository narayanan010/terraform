output "role_github_role_arn" {
  description = "Role github-actions arn for capterra staging"
  value       = aws_iam_role.github_actions.arn
}
