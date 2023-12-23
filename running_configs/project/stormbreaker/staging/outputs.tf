output "cloudfront_distro_id" {
  value       = aws_cloudfront_distribution.cf_stormbreaker.id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "cloudfront_function_arn" {
  value       = aws_cloudfront_function.rewrite_uri.arn
  description = "The ARN of Cloudfront function for rewrite"
}

output "aws_acm_certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
}

output "r53_dns_domain_name" {
  value       = aws_route53_record.dns_record.fqdn
  description = "The name of DNS record just created for Serverless App"
}

output "s3_primary_bucket_id" {
  value       = aws_s3_bucket.s3_stormbreaker.id
  description = "Name of the primary S3 bucket that serves as Origin for Cloudfront distribution"
}
