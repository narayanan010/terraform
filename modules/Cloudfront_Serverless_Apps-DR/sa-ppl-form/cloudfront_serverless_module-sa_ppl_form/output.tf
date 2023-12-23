output "account_alias" {
  value       = data.aws_iam_account_alias.current.account_alias
  description = "This is the name of account alias"
}

#output "s3_primary_bucket_id" {
#    value = "${aws_s3_bucket.cf_primary_bucket.id}"
#    description = "Name of the primary S3 bucket that serves as one of the origin for Cloudfront"
#}

#output "s3_primary_bucket_arn" {
#    value = "${aws_s3_bucket.cf_primary_bucket.arn}"
#    description = "The Amazon Resource Name (ARN) of the Primary S3 bucket that serves as one of the origin for Cloudfront"
#}

#output "s3_cf_log_bucket_id" {
#    value = "${aws_s3_bucket.cf_log_bucket.id}"
#    description = "Name of the Log S3 bucket that serves as log destination for Cloudfront"
#}

#output "s3_cf_log_bucket_arn" {
#    value = "${aws_s3_bucket.cf_log_bucket.arn}"
#    description = "The Amazon Resource Name (ARN) of the Log S3 bucket that serves as logging destination for Cloudfront"
#}

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

#output "cloudfront_OAI_id" {
#    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
#    description = "The ID of Cloudfront OAI just created for Serverless App"
#}

#output "cloudfront_OAI_iam_arn" {
#    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
#    description = "The iam_arn of Cloudfront OAI just created for Serverless App"
#}

output "r53_dns_domain_name" {
  value       = aws_route53_record.dns_record.name
  description = "The name of DNS record just created for Serverless App"
}

output "module_tags" {
  value = "${module.tags_resource_module.tags}"
  description = "The map tags for the resources" 
}
