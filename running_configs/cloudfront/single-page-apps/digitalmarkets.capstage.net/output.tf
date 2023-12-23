output "account_alias" {
  value = "${data.aws_iam_account_alias.current.account_alias}"
  description = "This is the name of account alias"
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

output "r53_dns_domain_name" {
    value = "${aws_route53_record.dns_record.name}"
    description = "The name of DNS record just created for Serverless App"
}