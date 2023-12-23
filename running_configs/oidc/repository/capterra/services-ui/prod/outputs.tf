
# Common Identity provider
############################################################
output "githuboidc_arn" {
  description = "OIDC GitHub arn"
  value       = data.terraform_remote_state.common_resources.outputs.githuboidc_arn
}

# Main role for Identity Provider (OIDC)
############################################################
output "role_github_sem_ui_role_arn" {
  description = "Role github-actions arn for services-ui staging"
  value       = aws_iam_role.github_actions_services_ui.arn
}

