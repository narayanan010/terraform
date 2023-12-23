resource "aws_cloudfront_distribution" "k8s_distribution" {

  origin {
    domain_name = var.default_origin_dns
    origin_id   = "origin-${var.default_origin_dns}"
    custom_header {
      name  = "x-cf-confirmed-header"
      value = var.secret_header_value
    }
    custom_origin_config {
      http_port             = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Distribution for ${var.default_origin_dns}"
  price_class     = "PriceClass_200"
  web_acl_id      = var.web_acl_arn != "" ? var.web_acl_arn : null

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  dynamic "logging_config" {
    for_each = var.is_logging_enabled ? [1] : []
    content {
      include_cookies = false
      bucket          = var.bucket_logging
      prefix          = var.bucket_prefix_logging
    }
  }

  aliases = var.cname_aliases
  viewer_certificate {
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    acm_certificate_arn            = var.acm_certificate_arn
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-${var.default_origin_dns}"

    cache_policy_id        = aws_cloudfront_cache_policy.k8s_distribution.id
    viewer_protocol_policy = "redirect-to-https"
    origin_request_policy_id = aws_cloudfront_origin_request_policy.Nginx_GeoIp_Country_Code.id
  }

}

resource "aws_cloudfront_cache_policy" "k8s_distribution" {
  name        = "${replace(lower(var.cname_aliases[0]), ".", "-")}-cache-policy"
  comment     = "Cache policy used by the distribution serving ${var.cname_aliases[0]}"
  default_ttl = 86400
  max_ttl     = 86400
  min_ttl     = 0
  
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = ["experiment-*"]
      }
    }
    headers_config {
          header_behavior = "whitelist"
    headers {
      items = ["Nginx_GeoIp_Country_Code"]
           }
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["q", "url", "w", "exp"]
      }
    }
    enable_accept_encoding_gzip = true
  }
}

resource "aws_cloudfront_origin_request_policy" "Nginx_GeoIp_Country_Code" {
  name    = "${replace(lower(var.cname_aliases[0]), ".", "-")}-origin-request-policy"
  comment = "Nginx_GeoIp_Country_Code for country code"
   cookies_config {
    cookie_behavior = "whitelist"
    cookies {
      items = ["featureSessionId"]
    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Nginx_GeoIp_Country_Code"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}

data "aws_cloudfront_cache_policy" "managed_caching_disabled" {
  name        = "Managed-CachingDisabled"
}
