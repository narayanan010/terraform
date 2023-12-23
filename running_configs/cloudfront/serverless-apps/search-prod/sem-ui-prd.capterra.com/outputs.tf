## Common OAC
# output "aws_cloudfront_origin_access_control" {
#   value       = aws_cloudfront_origin_access_control.origin_access_control
#   description = "Origin Access Control (OAC) Serverless Cloudfront"
# }

output "cloudfront_distro_id" {
  value       = aws_cloudfront_distribution.sem-ui-prod-E2NTTUAKIRGN2F.id
  description = "The ID of Cloudfront distribution just created for Serverless App"
}

output "aws_cloudfront_origin_access_control_id" {
  value       = aws_cloudfront_origin_access_control.origin_access_control.id
  description = "Origin Access Control (OAC) Serverless Cloudfront"
}

output "aws_s3_bucket_policy_sem-ui-prd-bucket-policy_id" {
  value       = aws_s3_bucket_policy.sem-ui-prd-bucket-policy.id
  description = "S3 bucket policy for CloudFront S3 Origin"
}

output "aws_s3_bucket_sem-ui-prd_id" {
  value       = aws_s3_bucket.sem-ui-prd.id
  description = "S3 bucket for CloudFront S3 Origin"
}