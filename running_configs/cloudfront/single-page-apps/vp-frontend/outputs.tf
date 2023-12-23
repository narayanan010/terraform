 output "cloudfront_distro_id" {
  value = "${module.cf_dist.cloudfront_distro_id}"
  description = "The ID of Cloudfront distribution just created for SPA (Single Page App)"  
}

  output "aws_acm_certificate_arn" {
  value = "${module.cf_dist.aws_acm_certificate_arn}"
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for SPA (Single Page App)"
}

  output "cloudfront_OAI_iam_arn" {
  value = "${module.cf_dist.cloudfront_OAI_iam_arn}"
  description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}

  output "r53_dns_domain_name" {
  value = "${module.cf_dist.r53_dns_domain_name}"
  description = "The name of DNS record just created for SPA (Single Page App)"
}

  output "s3_primary_bucket_id" {
  value = "${module.cf_dist.s3_primary_bucket_id}"
  description = "Name of the primary S3 bucket that serves as Source for xRegion Replication"
}

  output "s3_secondary_bucket_id" {
  value = "${module.cf_dist.s3_secondary_bucket_id}"
  description = "Name of the Secondary S3 bucket that serves as destination for xRegion Replication"
}