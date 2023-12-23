output "cloudfront_distro_id" {
  value       = module.cf_dist_serverless.cloudfront_distro_id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "aws_acm_certificate_arn" {
  value       = module.cf_dist_serverless.aws_acm_certificate_arn
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
}

#output "cloudfront_OAI_iam_arn" {
#	value = "${module.cf_dist_serverless.cloudfront_OAI_iam_arn}"
#	description = "The iam_arn of Cloudfront OAI just created for Serverless App"
#}

output "r53_dns_domain_name" {
  value       = module.cf_dist_serverless.r53_dns_domain_name
  description = "The name of DNS record just created for Serverless App"
}

#output "s3_primary_bucket_id" {
#	value = "${module.cf_dist_serverless.s3_primary_bucket_id}"
#	description = "Name of the primary S3 bucket that serves as Origin for Cloudfront distribution"
#}

#output "s3_cf_log_bucket_id" {
#	value = "${module.cf_dist_serverless.s3_cf_log_bucket_id}"
#	description = "Name of the Log S3 bucket that serves as Log Destination for Cloudfront distribution"
#}
