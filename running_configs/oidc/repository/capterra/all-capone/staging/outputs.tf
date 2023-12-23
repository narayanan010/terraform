output "role_github_cap_one_role_arn" {
  description = "Role github-actions arn for Cap One Staging"
  value       = aws_iam_role.github_actions_cap_one.arn
}
