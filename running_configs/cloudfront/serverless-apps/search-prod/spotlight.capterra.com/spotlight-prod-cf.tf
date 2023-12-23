# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "ERHKKXETLD4S4"
resource "aws_cloudfront_distribution" "spotlight-prod" {
  aliases             = ["spotlight.capterra.com"]
  comment             = null
  default_root_object = null
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  tags = {
    Environment = "production"
    Product     = "spotlight"
    Terraform   = "true"
    vertical    = "capterra"
  }
  tags_all = {
    Environment = "production"
    Product     = "spotlight"
    Terraform   = "true"
    vertical    = "capterra"
  }
  wait_for_deployment = true
  web_acl_id          = "arn:aws:wafv2:us-east-1:296947561675:global/webacl/capterra-search-prd-waf-dirpa/4b5f7214-1231-43b3-81ad-26da6c2a2a4c"
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 400
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 500
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 501
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 502
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 503
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 504
    response_code         = 0
    response_page_path    = null
  }
  default_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-api-gdm-spotlight-capterra-production"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = ["Nginx_GeoIp_Country_Code", "Referer", "user-agent"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = false
    prefix          = "296947561675/ERHKKXETLD4S4"
  }
  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = false
    default_ttl                = 31536000
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 31536000
    origin_request_policy_id   = null
    path_pattern               = "robots.txt"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "S3-spotlight-ui-prd/spotlight/assets"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 31536000
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 31536000
    origin_request_policy_id   = null
    path_pattern               = "spotlight/assets/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-s3-gdm-spotlight-capterra-production"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = false
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "/rest/v4/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-public-api-gdm-spotlight-capterra-prod-v4"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = false
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "/rest/v3/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-public-api-gdm-spotlight-capterra-prod-v3"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = false
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "rest/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-public-api-gdm-spotlight-capterra-production"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    forwarded_values {
      headers                 = []
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "5d3ci1gr87.execute-api.us-east-1.amazonaws.com"
    origin_access_control_id = null
    origin_id                = "origin-public-api-gdm-spotlight-capterra-production"
    origin_path              = "/prod"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "5r3j0crjv5.execute-api.us-east-1.amazonaws.com"
    origin_access_control_id = null
    origin_id                = "origin-public-api-gdm-spotlight-capterra-prod-v3"
    origin_path              = "/prod"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "cmr99tp21m.execute-api.us-east-1.amazonaws.com"
    origin_access_control_id = null
    origin_id                = "origin-public-api-gdm-spotlight-capterra-prod-v4"
    origin_path              = "/prod"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "drx0d1p6d6.execute-api.us-east-1.amazonaws.com"
    origin_access_control_id = null
    origin_id                = "origin-api-gdm-spotlight-capterra-production"
    origin_path              = "/prod"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "spotlight-ui-prd.s3.amazonaws.com"
    origin_access_control_id = "EMIUWVHNT1PVW"
    origin_id                = "S3-spotlight-ui-prd/spotlight/assets"
    origin_path              = "/spotlight/assets"
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "spotlight-ui-prd.s3.amazonaws.com"
    origin_access_control_id = "EMIUWVHNT1PVW"
    origin_id                = "origin-s3-gdm-spotlight-capterra-production"
    origin_path              = null
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:296947561675:certificate/1eae263f-52a9-491b-88db-7df3d2a0bf8a"
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
