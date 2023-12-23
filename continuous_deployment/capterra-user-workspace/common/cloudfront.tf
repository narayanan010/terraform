# OAC creation for Cloudfront Distribution. S3 buckets cannot have website endpoint enabled
resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "serverless-${var.name}"
  description                       = "OAC for serverless app named ${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
