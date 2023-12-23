output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "This is the name of account alias"
}
