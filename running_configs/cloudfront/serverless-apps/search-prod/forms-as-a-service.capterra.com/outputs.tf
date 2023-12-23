output "aws_cloudfront_distribution_faas-prod_id" {
  value = aws_cloudfront_distribution.faas-prod.id
}

output "aws_cloudfront_cache_policy_faas-prod-cache-policy_id" {
  value = aws_cloudfront_cache_policy.faas-prod-cache-policy.id
}