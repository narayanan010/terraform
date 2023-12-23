output "account_alias" {
  value = "${data.aws_iam_account_alias.current.account_alias}"
  description = "This is the name of account alias"
}

output "s3_primary_bucket_id" {
    value = "${aws_s3_bucket.cf_primary_bucket.id}"
    description = "Name of the primary S3 bucket that serves as Source for xRegion Replication"
}

output "s3_primary_bucket_arn" {
    value = "${aws_s3_bucket.cf_primary_bucket.arn}"
    description = "The Amazon Resource Name (ARN) of the Primary S3 bucket that serves as Source for xRegion Replication"
}

output "s3_secondary_bucket_id" {
    value = "${aws_s3_bucket.cf_secondary_bucket.id}"
    description = "Name of the Secondary S3 bucket that serves as destination for xRegion Replication"
}

output "s3_secondary_bucket_arn" {
    value = "${aws_s3_bucket.cf_secondary_bucket.arn}"
    description = "The Amazon Resource Name (ARN) of the Secondary S3 bucket that serves as destination for xRegion Replication"
}

output "iam_role_arn" {
    value = "${aws_iam_role.replication.arn}"
    description = "The Amazon Resource Name (ARN) of the IAM Role created for S3 Replication"
}

output "iam_policy_arn" {
    value = "${aws_iam_policy.replication.arn}"
    description = "The Amazon Resource Name (ARN) of the IAM Policy created for S3 Replication Role"
}

output "aws_acm_certificate_arn" {
	value = "${aws_acm_certificate.cert.arn}"
	description = "The Amazon Resource Name (ARN) of the ACM Certificate created for SPA (Single Page App)"
}

output "cloudfront_distro_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.id}"
    description = "The ID of Cloudfront distribution just created for SPA (Single Page App)"
}

output "cloudfront_distro_arn" {
    value = "${aws_cloudfront_distribution.s3_distribution.arn}"
    description = "The ARN of Cloudfront distribution just created for SPA (Single Page App)"
}

output "cloudfront_distro_domain_name" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    description = "The domain_name of Cloudfront distribution just created for SPA (Single Page App)"
}

output "cloudfront_OAI_id" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
    description = "The ID of Cloudfront OAI just created for SPA (Single Page App)"
}

output "cloudfront_OAI_iam_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
    description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}

output "r53_dns_domain_name" {
    value = "${aws_route53_record.dns_record.name}"
    description = "The name of DNS record just created for SPA (Single Page App)"
}