output "role_github_static_ui_role_arn" {
  description = "Role github-actions arn for Search staging"
  value       = aws_iam_role.github_actions_search.arn
}
