output "role_github_compare_ui_role_arn" {
  description = "Role github-actions arn for Compare-ui staging"
  value       = aws_iam_role.github_actions_compare_ui.arn
}
