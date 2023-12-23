resource "aws_cloudfront_origin_request_policy" "custom" {
  name    = "${var.application}-${var.environment}-origin-request-policy"
  comment = "This is for custom origin request policy for ${var.application}"
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["CloudFront-Viewer-Address", "CloudFront-Viewer-Country", "CloudFront-Viewer-Country-Region",
      "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer"]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}