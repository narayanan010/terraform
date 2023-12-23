output "role_github_global_nav_mf_role_arn" {
  description = "Role github-actions arn for global-nav-mf staging"
  value       = aws_iam_role.github_actions_global_nav_mf.arn
}
