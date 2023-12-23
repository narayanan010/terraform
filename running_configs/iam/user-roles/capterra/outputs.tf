output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "Name of account alias"
}

output "admin_role" {
  value       = concat([aws_iam_role.admin_mfa.name], [aws_iam_role.admin_mfa.arn])
  description = "Name of admin role"
}

output "readonly_role" {
  value       = concat([aws_iam_role.readonly_mfa.name], [aws_iam_role.readonly_mfa.arn])
  description = "Name of readonly role"
}

output "developer_role" {
  value       = concat([aws_iam_role.developer_mfa.name], [aws_iam_role.developer_mfa.arn])
  description = "Name of developer role"
}

output "deployer_role" {
  value       = concat([aws_iam_role.deployer_mfa.name], [aws_iam_role.deployer_mfa.arn])
  description = "Name of deployer role"
}

# #Output for capterra account
output "group_arn_for_capterra_admin_role" {
  value       = concat([aws_iam_group.capterra_admin_mfa.id], [aws_iam_group.capterra_admin_mfa.arn])
  description = "ARN of group with assume permissions for admin role in capterra account"
}

output "group_arn_for_capterra_developer_role" {
  value       = concat([aws_iam_group.capterra_developer_mfa.id], [aws_iam_group.capterra_developer_mfa.arn])
  description = "ARN of group with assume permissions for developer role in capterra account"
}

output "group_arn_for_capterra_readonly_role" {
  value       = concat([aws_iam_group.capterra_readonly_mfa.id], [aws_iam_group.capterra_readonly_mfa.arn])
  description = "ARN of group with assume permissions for readonly role in capterra account"
}

output "group_arn_for_capterra_deployer_role" {
  value       = concat([aws_iam_group.capterra_deployer_mfa.id], [aws_iam_group.capterra_deployer_mfa.arn])
  description = "ARN of group with assume permissions for deployer role in capterra account"
}

# GDM 
##########
output "role_ccoe_jenkins" {
  value       = concat([aws_iam_role.assume_role_ccoe_jenkins.name], [aws_iam_role.assume_role_ccoe_jenkins.arn])
  description = "Role ccoe_jenkins created"
}
