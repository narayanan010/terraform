output "cloudfront_distro_id" {
  value       = aws_cloudfront_distribution.EX1PQUUEWBRJL.id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "cloudfront_distro_arn" {
  value       = aws_cloudfront_distribution.EX1PQUUEWBRJL.arn
  description = "The ARN of Cloudfront distribution just created for Serverless App"
}

output "cloudfront_distro_domain_name" {
  value       = aws_cloudfront_distribution.EX1PQUUEWBRJL.domain_name
  description = "The domain_name of Cloudfront distribution just created for Serverless App"
}
