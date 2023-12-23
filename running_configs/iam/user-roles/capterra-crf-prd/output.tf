output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "Name of account alias"
}

output "admin_role" {
  value       = aws_iam_role.admin_mfa.name
  description = "Name of admin role"
}

output "readonly_role" {
  value       = aws_iam_role.readonly_mfa.name
  description = "Name of readonly role"
}

output "developer_role" {
  value       = aws_iam_role.developer_mfa.name
  description = "Name of developer role"
}

output "deployer_role" {
  value       = aws_iam_role.deployer_mfa.name
  description = "Name of deployer role"
}

#Output for capterra-crf-prd account
output "group_arn_for_capterra-crf-prd_admin_role" {
  value       = aws_iam_group.capterra_crf_prd_admin_mfa.arn
  description = "ARN of group with assume permissions for admin role in capterra-crf-prd account"
}

output "group_arn_for_capterra-crf-prd_developer_role" {
  value       = aws_iam_group.capterra_crf_prd_developer_mfa.arn
  description = "ARN of group with assume permissions for developer role in capterra-crf-prd account"
}

output "group_arn_for_capterra-crf-prd_readonly_role" {
  value       = aws_iam_group.capterra_crf_prd_readonly_mfa.arn
  description = "ARN of group with assume permissions for readonly role in capterra-crf-prd account"
}

output "group_arn_for_capterra-crf-prd_deployer_role" {
  value       = aws_iam_group.capterra_crf_prd_deployer_mfa.arn
  description = "ARN of group with assume permissions for deployer role in capterra-crf-prd account"
}
