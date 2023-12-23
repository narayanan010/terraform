/*resource "aws_cloudfront_cache_policy" "redirect_lambda" {
  provider    = aws.primary_cf_account
  name        = "${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda-cache-redirect-policy"
  comment     = "redirect-${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}*/

resource "aws_cloudfront_cache_policy" "standard" {
  provider    = aws.primary_cf_account
  name        = "${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda-cache-standard-policy"
  comment     = "redirect-${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

resource "aws_cloudfront_cache_policy" "default" {
  provider    = aws.primary_cf_account
  name        = "${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda-cache-default-policy"
  comment     = "redirect-${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}