data "aws_cloudfront_origin_request_policy" "custom" {
  name = "${var.application}-${var.environment}-origin-request-policy"
}