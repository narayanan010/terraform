output "role_github_role_arn" {
  description = "Role github-actions arn for stormbreaker-ui staging"
  value       = aws_iam_role.github_actions_stormbreaker.arn
}
