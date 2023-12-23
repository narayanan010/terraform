output "githuboidc_arn" {
  description = "OIDC GitHub arn"
  value       = aws_iam_openid_connect_provider.githuboidc.arn
}
