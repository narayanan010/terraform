output "s3_bucket_name" {
  value = "${aws_s3_bucket.as3b.id}"
  description = "Name of s3 bucket created."
}

output "s3_access_point_ARN" {
  value = "${aws_s3_access_point.as3ap.arn}"
  description = "ARN of S3 Access Point Created."
}

output "s3_access_point_domain-name" {
  value = "${aws_s3_access_point.as3ap.domain_name}"
  description = "domain-name of S3 Access Point Created."
}

output "s3_access_point_ID" {
  value = "${aws_s3_access_point.as3ap.id}"
  description = "ID of S3 Access Point Created."
}

output "s3_access_point_network-origin" {
  value = "${aws_s3_access_point.as3ap.network_origin}"
  description = "Network-origin type of S3 Access Point Created."
}

output "kms_arn" {
  value = "${aws_kms_key.akk.arn}"
  description = "ARN of KMS key."
}

output "kms_key_id" {
  value = "${aws_kms_key.akk.key_id}"
  description = "The globally unique identifier of the KMS key."
}