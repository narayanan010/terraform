output "aws_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.k8s_distribution.id
}

output "aws_cloudfront_distribution_dns" {
  value = aws_cloudfront_distribution.k8s_distribution.domain_name
}
