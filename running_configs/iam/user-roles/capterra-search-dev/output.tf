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

output "deployer-policy-2" {
  value       = aws_iam_policy.deployer-iam-search.arn
  description = "This is arn of assume deployer policy"
}

output "deployer-policy-3" {
  value       = aws_iam_policy.dynamodb_rw.arn
  description = "This is arn of assume deployer policy"
}

output "deployer-policy-iam" {
  value       = aws_iam_policy.deployer-iam-spotlight.arn
  description = "This is arn of assume deployer policy"
}

output "developer-policy-2" {
  value       = aws_iam_policy.developer-iam.arn
  description = "This is arn of assume developer policy"
}

#Output for capterra-search-dev account
output "group_arn_for_capterra-search-dev_admin_role" {
  value       = aws_iam_group.capterra_search_dev_admin_mfa.arn
  description = "ARN of group with assume permissions for admin role in capterra-search-dev account"
}

output "group_arn_for_capterra-search-dev_developer_role" {
  value       = aws_iam_group.capterra_search_dev_developer_mfa.arn
  description = "ARN of group with assume permissions for developer role in capterra-search-dev account"
}

output "group_arn_for_capterra-search-dev_readonly_role" {
  value       = aws_iam_group.capterra_search_dev_readonly_mfa.arn
  description = "ARN of group with assume permissions for readonly role in capterra-search-dev account"
}

output "group_arn_for_capterra-search-dev_deployer_role" {
  value       = aws_iam_group.capterra_search_dev_deployer_mfa.arn
  description = "ARN of group with assume permissions for deployer role in capterra-search-dev account"
}
