output "aws_s3_bucket_capterra-rep_id" {
  value = "${aws_s3_bucket.capterra-rep.id}"
}

output "aws_s3_bucket_capterra-staging-rep-us-west-2_id" {
  value = "${aws_s3_bucket.capterra-staging-rep-us-west-2.id}"
}

output "aws_s3_bucket_capterra-storage-gateway-rep_id" {
  value = "${aws_s3_bucket.capterra-storage-gateway-rep.id}"
}

output "aws_s3_bucket_gdm-capterra-db-backup-rep_id" {
  value = "${aws_s3_bucket.gdm-capterra-db-backup-rep.id}"
}

output "aws_s3_bucket_policy_capterra-rep_id" {
  value = "${aws_s3_bucket_policy.capterra-rep.id}"
}
