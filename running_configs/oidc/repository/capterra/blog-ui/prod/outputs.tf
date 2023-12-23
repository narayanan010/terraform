output "role_github_blog_ui_role_arn" {
  description = "Role github-actions arn for Blog-ui Prod"
  value       = aws_iam_role.github_actions_blog_ui.arn
}
