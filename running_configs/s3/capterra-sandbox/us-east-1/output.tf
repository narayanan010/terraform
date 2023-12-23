output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "This is the name of account alias"
}

output "athena-bucket-sandbox" {
  value       = aws_s3_bucket.athena-bucket-sandbox.arn
  description = "This is arn of s3-bucket1"
}

output "capterra-terraform-state-944864126557" {
  value       = aws_s3_bucket.capterra-terraform-state-944864126557.arn
  description = "This is arn of s3-bucket2"
}

output "cptra-logs-staging" {
  value       = aws_s3_bucket.cptra-logs-staging.arn
  description = "This is arn of s3-bucket4"
}

output "cptra-cf-logs" {
  value       = aws_s3_bucket.cptra-cf-logs.arn
  description = "This is arn of s3-bucket5"
}
