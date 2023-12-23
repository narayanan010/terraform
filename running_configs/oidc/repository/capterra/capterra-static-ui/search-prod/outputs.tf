output "role_github_static_ui_role_arn" {
  description = "Role github-actions arn for Static-ui staging"
  value       = aws_iam_role.github_actions_static_ui.arn
}
