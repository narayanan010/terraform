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

output "deployer-policy-iam" {
  value       = aws_iam_policy.deployer-iam.arn
  description = "This is arn of assume deployer policy"
}

output "developer-policy-iam" {
  value       = aws_iam_policy.developer-iam.arn
  description = "This is arn of assume developer policy"
}

output "developer-policy-intl-api" {
  value       = aws_iam_policy.developer-intl-api.arn
  description = "This is arn of assume developer policy"
}

#Output for capterra-search-prod account
output "group_arn_for_capterra-search-prod_admin_role" {
  value       = aws_iam_group.capterra_search_prod_admin_mfa.arn
  description = "ARN of group with assume permissions for admin role in capterra-search-prod account"
}

output "group_arn_for_capterra-search-prod_developer_role" {
  value       = aws_iam_group.capterra_search_prod_developer_mfa.arn
  description = "ARN of group with assume permissions for developer role in capterra-search-prod account"
}

output "group_arn_for_capterra-search-prod_readonly_role" {
  value       = aws_iam_group.capterra_search_prod_readonly_mfa.arn
  description = "ARN of group with assume permissions for readonly role in capterra-search-prod account"
}

output "group_arn_for_capterra-search-prod_deployer_role" {
  value       = aws_iam_group.capterra_search_prod_deployer_mfa.arn
  description = "ARN of group with assume permissions for deployer role in capterra-search-prod account"
}
