# Main role for Identity Provider (OIDC)
############################################################
output "role_oidc_github" {
  description = "Role github-actions arn for spotlight-ui prod"
  value       = aws_iam_role.github_actions_spotlight_ui.arn
}
