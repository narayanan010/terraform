resource "aws_cloudfront_distribution" "s3_distribution" {
  comment    = "This is for hosting Prod env of serverless app named - UpCity"
  web_acl_id = data.aws_wafv2_web_acl.crf.arn
  aliases    = ["reviews.upcity.com"]

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "502"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "416"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "414"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "500"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "400"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "504"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "501"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "405"
    response_code         = "0"
  }

  default_cache_behavior {
    allowed_methods = ["OPTIONS", "GET", "DELETE", "HEAD", "PATCH", "PUT", "POST"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Referer", "Authorization"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "false"

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = "false"
    prefix          = "crf-upcity-log"
  }

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "OPTIONS", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      #headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer"]
      headers      = ["Authorization"]
      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-upcity-prod"
    viewer_protocol_policy = "redirect-to-https"
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
    target_origin_id           = "S3-crf-upcity-prd-cdn"
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
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "robots.txt"
    smooth_streaming       = "false"
    target_origin_id       = "S3-crf-upcity-prd-cdn"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    path_pattern           = "_next/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-upcity-prod"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "k8s/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "fsrelay/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "providers/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
      query_string = "true"
    }

    path_pattern           = "static/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
      query_string = "true"
    }

    path_pattern           = "search*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Authorization", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer"]
      query_string = "true"
    }

    path_pattern           = "validate/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capterra.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  # ordered_cache_behavior {
  #   allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  #   cached_methods  = ["GET", "HEAD"]
  #   compress        = "true"

  #   forwarded_values {
  #     cookies {
  #       forward = "all"
  #     }

  #     headers      = ["Authorization", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
  #     query_string = "true"
  #   }

  #   path_pattern           = "products/*"
  #   smooth_streaming       = "false"
  #   target_origin_id       = "k8s-reviews.capterra.com"
  #   viewer_protocol_policy = "redirect-to-https"
  # }

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
  # ordered_cache_behavior {
  #   allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  #   cache_policy_id            = null
  #   cached_methods             = ["GET", "HEAD"]
  #   compress                   = true
  #   default_ttl                = 0
  #   field_level_encryption_id  = null
  #   max_ttl                    = 0
  #   min_ttl                    = 0
  #   origin_request_policy_id   = null
  #   path_pattern               = "mew/*"
  #   realtime_log_config_arn    = null
  #   response_headers_policy_id = null
  #   smooth_streaming           = false
  #   target_origin_id           = "k8s-reviews.capterra.com"
  #   trusted_key_groups         = []
  #   trusted_signers            = []
  #   viewer_protocol_policy     = "redirect-to-https"
  #   forwarded_values {
  #     headers                 = ["Authorization", "Referer"]
  #     query_string            = true
  #     query_string_cache_keys = []
  #     cookies {
  #       forward           = "all"
  #       whitelisted_names = []
  #     }
  #   }
  # }

  # ordered_cache_behavior {
  #   allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  #   cached_methods  = ["GET", "HEAD"]
  #   compress        = "true"
  #   default_ttl     = "0"
  #   forwarded_values {
  #     cookies {
  #       forward = "all"
  #     }
  #     headers      = ["Authorization", "Referer"]
  #     query_string = "true"
  #   }
  #   max_ttl                = "0"
  #   min_ttl                = "0"
  #   path_pattern           = "new/*"
  #   smooth_streaming       = "false"
  #   target_origin_id       = "origin-api-gdm-crf-upcity-prod"
  #   viewer_protocol_policy = "redirect-to-https"

  # }

  origin {

    domain_name = "central-review-form-prd.s3.amazonaws.com"
    origin_id   = "origin-s3-gdm-crf-upcity-prod"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name = "central-review-form-prd.s3.amazonaws.com"
    origin_id   = "S3-central-review-form-prod/assets"
    origin_path = "/assets"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "crf-prod-cdn.s3.amazonaws.com"
    origin_access_control_id = var.cf_origin_access_control
    origin_id                = "S3-crf-upcity-prd-cdn"
  }

  origin {
    custom_header {
      name  = "x-gdm-source-site"
      value = "UpCity"
    }

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.2"]
    }

    domain_name = "tua9jegyrj.execute-api.us-east-1.amazonaws.com"
    origin_id   = "origin-api-gdm-crf-upcity-prod"
    origin_path = "/prod"
  }

  origin {
    custom_header {
      name  = "x-gdm-source-site"
      value = "UpCity"
    }
    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.2"]
    }

    domain_name = "k8s-reviews.capterra.com"
    origin_id   = "k8s-reviews.capterra.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:738909422062:certificate/ae31a1f5-7489-45a0-9686-20bc808135b3"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}
