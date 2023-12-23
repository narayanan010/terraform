# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "EQXIR6ZYUOPZ8"
resource "aws_cloudfront_distribution" "reviews-sa-prod" {
  aliases             = ["reviews.softwareadvice.com"]
  comment             = null
  default_root_object = null
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  tags = {
    Environment = "prd"
    Product     = "crf"
    Terraform   = "true"
    vertical    = "softwareadvice"
  }
  tags_all = {
    Environment = "prd"
    Product     = "crf"
    Terraform   = "true"
    vertical    = "softwareadvice"
  }
  wait_for_deployment = true
  web_acl_id          = var.aws_wafv2_web_acl_name
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 400
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 414
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 416
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 500
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 501
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 502
    response_code         = 0
    response_page_path    = null
  }
  custom_error_response {
    error_caching_min_ttl = 10
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
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"]
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
    prefix          = "738909422062/EQXIR6ZYUOPZ8"
  }
  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 31536000
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 31536000
    origin_request_policy_id   = null
    path_pattern               = "assets/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-s3-gdm-crf-softwareadvice-prd"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization"]
      query_string            = false
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 86400
    min_ttl                    = 86400
    origin_request_policy_id   = null
    path_pattern               = "cdn/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "S3-crf-sa-prd-cdn"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization"]
      query_string            = false
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 31536000
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 31536000
    origin_request_policy_id   = null
    path_pattern               = "robots.txt"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "S3-crf-sa-prd-cdn"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization"]
      query_string            = false
      query_string_cache_keys = []
      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "_next/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-s3-gdm-crf-softwareadvice-prd"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "k8s/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Viewer-Country"]
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
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "fsrelay/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "providers/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Viewer-Country"]
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
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "static/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Android-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "search*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Android-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "validate/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "products/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "CloudFront-Is-Android-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 86400
    field_level_encryption_id  = null
    max_ttl                    = 31536000
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "v/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
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
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "mew/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "origin-api-gdm-crf-softwareadvice-prd"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "Referer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id            = null
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    path_pattern               = "new/*"
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = "k8s-reviews.capterra.com"
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "redirect-to-https"
    forwarded_values {
      headers                 = ["Authorization", "Referer"]
      query_string            = true
      query_string_cache_keys = []
      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "tua9jegyrj.execute-api.us-east-1.amazonaws.com"
    origin_access_control_id = null
    origin_id                = "origin-api-gdm-crf-softwareadvice-prd"
    origin_path              = "/prod"
    custom_header {
      name  = "x-gdm-source-site"
      value = "SoftwareAdvice"
    }
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
    domain_name              = "k8s-reviews.capterra.com"
    origin_access_control_id = null
    origin_id                = "k8s-reviews.capterra.com"
    origin_path              = null
    custom_header {
      name  = "x-gdm-source-site"
      value = "SoftwareAdvice"
    }
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "central-review-form-prd.s3.amazonaws.com"
    origin_access_control_id = var.cf_origin_access_control
    origin_id                = "S3-central-review-form-prd/assets"
    origin_path              = "/assets"
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "crf-prod-cdn.s3.amazonaws.com"
    origin_access_control_id = var.cf_origin_access_control
    origin_id                = "S3-crf-sa-prd-cdn"
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "central-review-form-prd.s3.amazonaws.com"
    origin_access_control_id = var.cf_origin_access_control
    origin_id                = "origin-s3-gdm-crf-softwareadvice-prd"
    origin_path              = null
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:738909422062:certificate/e56b6d27-e0a9-4c4e-867e-86b49e900c19"
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}
