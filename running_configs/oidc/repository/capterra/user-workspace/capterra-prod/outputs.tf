output "role_github_user_workspace_role_arn" {
  description = "Role github-actions arn for user-workspace Prod"
  value       = aws_iam_role.github_actions_user_workspace.arn
}
