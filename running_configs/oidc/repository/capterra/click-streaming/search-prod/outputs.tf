# Main role for Identity Provider (OIDC)
############################################################
output "role_oidc_github" {
  description = "Role github-actions arn for clicks streaming prod & prod-dr"
  value       = aws_iam_role.github_actions_clicks_streaming.arn
}
