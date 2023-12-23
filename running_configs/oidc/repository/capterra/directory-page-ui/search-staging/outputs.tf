output "role_github_dirpa_ui_role_arn" {
  description = "Role github-actions arn for Directory-Page-ui staging"
  value       = aws_iam_role.github_actions_dirpa_ui.arn
}
