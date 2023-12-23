output "role_github_role_arn" {
  description = "Role github-actions arn"
  value       = aws_iam_role.github_actions.arn
}

output "githuboidc_arn" {
  description = "OIDC GitHub arn"
  value       = aws_iam_openid_connect_provider.githuboidc.arn
}

output "thumbprints" {
  value = local.thumbprints
}

output "role_databases_github_role_arn" {
  description = "Role github-actions arn"
  value       = aws_iam_role.databases_deployer_github_actions.arn
}