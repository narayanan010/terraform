# Main role for Identity Provider (OIDC)
############################################################
output "role_github_actions_vendor_portal_fe" {
  description = "Role github-actions arn for staging"
  value       = aws_iam_role.github_actions_vendor_portal_fe.arn
}
