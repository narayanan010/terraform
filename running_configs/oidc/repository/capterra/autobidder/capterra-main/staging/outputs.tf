output "role_github_arn" {
  description = "Role github-actions ARN"
  value       = aws_iam_role.github_actions_autobidder.arn
}
