# Common Identity provider
############################################################
output "githuboidc_arn" {
  description = "OIDC GitHub arn"
  value       = data.terraform_remote_state.common_resources.outputs.githuboidc_arn
}


# Main role for Identity Provider (OIDC)
############################################################
output "role_oidc_github" {
  description = "Role github-actions arn for search-dev"
  value       = aws_iam_role.github_actions.arn
}
