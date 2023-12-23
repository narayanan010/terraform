## Common OAC
output "aws_cloudfront_origin_access_control" {
  value       = aws_cloudfront_origin_access_control.origin_access_control
  description = "Origin Access Control (OAC) Serverless Cloudfront"
}