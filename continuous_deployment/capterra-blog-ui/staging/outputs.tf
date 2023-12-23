output "aws_cloudfront_distribution_id" {
  value       = module.cloudfront_distribution.aws_cloudfront_distribution_id
  description = "The ID of Cloudfront distribution to serve blog-ui."
}

output "aws_cloudfront_distribution_dns" {
  value       = module.cloudfront_distribution.aws_cloudfront_distribution_dns
  description = "The DNS of Cloudfront distribution to serve blog-ui."
}
