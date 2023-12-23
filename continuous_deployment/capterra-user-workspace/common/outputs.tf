## Common Cache Policies
output "cache_policy_redirect_lambda" {
  value       = aws_cloudfront_cache_policy.redirect_lambda
  description = "Policy redirect_lambda for Serverless Cloudfront"
}

output "cache_policy_standard" {
  value       = aws_cloudfront_cache_policy.standard
  description = "Policy standard for Serverless Cloudfront"
}

output "cache_policy_default" {
  value       = aws_cloudfront_cache_policy.default
  description = "Policy default for Serverless Cloudfront"
}

## Common OAC
output "aws_cloudfront_origin_access_control" {
  value       = aws_cloudfront_origin_access_control.origin_access_control
  description = "Origin Access Control (OAC) Serverless Cloudfront"
}