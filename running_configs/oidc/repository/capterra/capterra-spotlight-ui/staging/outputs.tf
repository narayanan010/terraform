output "role_github_spotlight_ui_role_arn" {
  description = "Role github-actions arn for spotlight_ui staging"
  value       = aws_iam_role.github_actions_spotlight_ui.arn
}
