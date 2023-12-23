output "aws_cloudfront_distribution_spotlight-prod_id" {
  value = aws_cloudfront_distribution.spotlight-prod.id
}

output "aws_cloudfront_origin_access_control_spotlight-prod_oac_id" {
  value = aws_cloudfront_origin_access_control.spotlight_prod_oac.id
}

output "aws_s3_bucket_spotlight-prod_id" {
  value = aws_s3_bucket.spotlight-ui-prd-bucket.id
}