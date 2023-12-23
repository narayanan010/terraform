output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "Name of account alias"
}

output "admin_role_mfa" {
  value       = aws_iam_role.admin_mfa.name
  description = "Name of admin MFA role"
}

output "readonly_role_mfa" {
  value       = aws_iam_role.readonly_mfa.name
  description = "Name of readonly MFA role"
}

output "developer_role_mfa" {
  value       = aws_iam_role.developer_mfa.name
  description = "Name of developer MFA role"
}

output "deployer_role_mfa" {
  value       = aws_iam_role.deployer_mfa.name
  description = "Name of deployer MFA role"
}

output "deployer_custom_policy" {
  value       = aws_iam_policy.deployer.arn
  description = "ARN of custom policy for deployer MFA role"
}

#Output for capterra-aws-admin account
output "group_arn_for_capterra-orange-staging_admin_role_mfa" {
  value       = aws_iam_group.capterra_orange_staging_admin_mfa.arn
  description = "ARN of group with assume permissions for admin MFA role in capterra-orange-staging account"
}

output "group_arn_for_capterra-orange-staging_developer_role_mfa" {
  value       = aws_iam_group.capterra_orange_staging_developer_mfa.arn
  description = "ARN of group with assume permissions for developer MFA role in capterra-orange-staging account"
}

output "group_arn_for_capterra-orange-staging_readonly_role_mfa" {
  value       = aws_iam_group.capterra_orange_staging_readonly_mfa.arn
  description = "ARN of group with assume permissions for readonly MFA role in capterra-orange-staging account"
}

output "group_arn_for_capterra-orange-staging_deployer_role_mfa" {
  value       = aws_iam_group.capterra_orange_staging_deployer_mfa.arn
  description = "ARN of group with assume permissions for deployer MFA role in capterra-orange-staging account"
}

output "group_arn_for_capterra-orange-staging_admin_role" {
  value       = aws_iam_group.capterra_orange_staging_admin.arn
  description = "ARN of group with assume permissions for admin role in capterra-orange-staging account"
}
output "group_arn_for_capterra-orange-staging_developer_role" {
  value       = aws_iam_group.capterra_orange_staging_developer.arn
  description = "ARN of group with assume permissions for developer role in capterra-orange-staging account"
}
output "group_arn_for_capterra-orange-staging_readonly_role" {
  value       = aws_iam_group.capterra_orange_staging_readonly.arn
  description = "ARN of group with assume permissions for readonly role in capterra-orange-staging account"
}
output "group_arn_for_capterra-orange-staging_deployer_role" {
  value       = aws_iam_group.capterra_orange_staging_deployer.arn
  description = "ARN of group with assume permissions for deployer role in capterra-orange-staging account"
}
