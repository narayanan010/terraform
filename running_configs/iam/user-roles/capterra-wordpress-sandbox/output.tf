output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "Name of account alias"
}

output "admin_role_mfa" {
  value       = aws_iam_role.admin_mfa.name
  description = "Name of admin role"
}

output "readonly_role_mfa" {
  value       = aws_iam_role.readonly_mfa.name
  description = "Name of readonly role"
}

output "developer_role_mfa" {
  value       = aws_iam_role.developer_mfa.name
  description = "Name of developer role"
}

output "deployer_role_mfa" {
  value       = aws_iam_role.deployer_mfa.name
  description = "Name of deployer role"
}

output "admin_role" {
  value       = aws_iam_role.admin.name
  description = "Name of admin role"
}

output "readonly_role" {
  value       = aws_iam_role.readonly.name
  description = "Name of readonly role"
}

output "developer_role" {
  value       = aws_iam_role.developer.name
  description = "Name of developer role"
}

output "deployer_role" {
  value       = aws_iam_role.deployer.name
  description = "Name of deployer role"
}

output "deployer_custom_policy" {
  value       = aws_iam_policy.deployer.arn
  description = "ARN of custom policy for deployer role"
}

#Output for capterra-aws-admin account
output "group_arn_for_capterra-wordpress-sandbox_admin_role_mfa" {
  value       = aws_iam_group.capterra_wordpress_sandbox_admin_mfa.arn
  description = "ARN of group with assume permissions for admin role in capterra-wordpress-sandbox account"
}

output "group_arn_for_capterra-wordpress-sandbox_developer_role_mfa" {
  value       = aws_iam_group.capterra_wordpress_sandbox_developer_mfa.arn
  description = "ARN of group with assume permissions for developer role in capterra-wordpress-sandbox account"
}

output "group_arn_for_capterra-wordpress-sandbox_readonly_role_mfa" {
  value       = aws_iam_group.capterra_wordpress_sandbox_readonly_mfa.arn
  description = "ARN of group with assume permissions for readonly role in capterra-wordpress-sandbox account"
}

output "group_arn_for_capterra-wordpress-sandbox_deployer_role_mfa" {
  value       = aws_iam_group.capterra_wordpress_sandbox_deployer_mfa.arn
  description = "ARN of group with assume permissions for deployer role in capterra-wordpress-sandbox account"
}

output "group_arn_for_capterra-wordpress-sandbox_admin_role" {
  value       = aws_iam_group.capterra_wordpress_sandbox_admin.arn
  description = "ARN of group with assume permissions for admin role in capterra-wordpress-sandbox account"
}
output "group_arn_for_capterra-wordpress-sandbox_developer_role" {
  value       = aws_iam_group.capterra_wordpress_sandbox_developer.arn
  description = "ARN of group with assume permissions for developer role in capterra-wordpress-sandbox account"
}
output "group_arn_for_capterra-wordpress-sandbox_readonly_role" {
  value       = aws_iam_group.capterra_wordpress_sandbox_readonly.arn
  description = "ARN of group with assume permissions for readonly role in capterra-wordpress-sandbox account"
}
output "group_arn_for_capterra-wordpress-sandbox_deployer_role" {
  value       = aws_iam_group.capterra_wordpress_sandbox_deployer.arn
  description = "ARN of group with assume permissions for deployer role in capterra-wordpress-sandbox account"
}
