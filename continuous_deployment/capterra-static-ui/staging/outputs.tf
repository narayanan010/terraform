output "cloudfront_distro_id" {
  value       = module.cf_dist_serverless.cloudfront_distro_id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "aws_acm_certificate_arn" {
  value       = module.cf_dist_serverless.aws_acm_certificate_arn
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
}

output "r53_dns_domain_name" {
  value       = module.cf_dist_serverless.r53_dns_domain_name
  description = "The name of DNS record just created for Serverless App"
}
