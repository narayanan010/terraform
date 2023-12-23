output "aws_acm_certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless Apps"
}

output "cloudfront_distro_id" {
  value       = aws_cloudfront_distribution.s3_distribution.id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "cloudfront_distro_arn" {
  value       = aws_cloudfront_distribution.s3_distribution.arn
  description = "The ARN of Cloudfront distribution just created for Serverless App"
}

output "cloudfront_distro_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The domain_name of Cloudfront distribution just created for Serverless App"
}

output "r53_dns_domain_name" {
  value       = aws_route53_record.dns_record.name
  description = "The name of DNS record just created for Serverless App"
}