output "role_github_sem_ui_role_arn" {
  description = "Role github-actions arn for Sem-ui staging"
  value       = aws_iam_role.github_actions_sem_ui.arn
}
