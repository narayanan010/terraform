output "role_github_cap_one_role_arn" {
  description = "Role github-actions arn for Cap One Prod"
  value       = aws_iam_role.github_actions_cap_one.arn
}
