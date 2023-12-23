resource "aws_cloudfront_cache_policy" "custom" {
  name        = "${var.application}-${var.environment}-caching-policy"
  comment     = "This is for custom caching policy for ${var.application}"
  default_ttl = 1
  max_ttl     = 1
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Authorization",
          "CloudFront-Viewer-Country", "CloudFront-Viewer-Country-Region",
          "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer",
          "hash",
        "x-cypress-forwarded-for", "x-cypress-auth-code", "x-cypress-rx-auth-code", "x-gdm-source-site"]
      }
    }
    query_strings_config {
      query_string_behavior = "all"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

# This section contains the available cache policies
data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "managed_caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "managed_all_viewer" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_origin_request_policy" "managed_cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}
