resource "aws_cloudfront_distribution" "tfer--EXDIOT4JLQSZ4" {
  comment    = "Staging CRF - GetApp"
  aliases    = ["reviews.gappdev.com"]
  web_acl_id = data.aws_wafv2_web_acl.crf.arn

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "414"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "416"
    response_code         = "0"
  }
  
  custom_error_response {
    error_caching_min_ttl = 10 
    error_code            = 404
    response_code         = 404
    response_page_path    = "/search"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "504"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "502"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "400"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "500"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "501"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "0"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "POST", "PATCH", "HEAD", "GET", "OPTIONS", "PUT"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Cloudfront-Is-Tablet-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Viewer-Country", "CloudFront-Is-Desktop-Viewer"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "origin-api-gdm-crf-getapp-stg"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "false"

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = "false"
    prefix          = "350125959894/EXDIOT4JLQSZ4"
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

      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-getapp-stg"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "OPTIONS", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "86400"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "86400"
    min_ttl                = "86400"
    path_pattern           = "cdn/*"
    smooth_streaming       = "false"
    target_origin_id       = "S3-crf-getapp-staging-cdn"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "static/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 31536000
    max_ttl                = 31536000
    min_ttl                = 31536000
    path_pattern           = "robots.txt"
    smooth_streaming       = false
    target_origin_id       = "S3-crf-getapp-staging-cdn"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

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
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "_next/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-crf-getapp-stg"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "providers/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-SmartTV-Viewer",
        "CloudFront-Is-Tablet-Viewer",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "k8s/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-SmartTV-Viewer",
        "CloudFront-Is-Tablet-Viewer",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }
  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.custom.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress                 = true
    default_ttl              = 0
    max_ttl                  = 0
    min_ttl                  = 0
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.custom.id
    path_pattern             = "products/*"
    smooth_streaming         = false
    target_origin_id         = "k8s-reviews.capstage.net"
    trusted_key_groups       = []
    trusted_signers          = []
    viewer_protocol_policy   = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "fsrelay/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.custom.id
  }

  ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "mew/*"
    smooth_streaming       = false
    target_origin_id       = "origin-api-gdm-crf-getapp-stg"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = data.aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.custom.id
  }

   ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
      cached_methods = [
       "GET",
       "HEAD",
       ]

      forwarded_values {
       query_string            = false
          cookies {
             forward           = "none"
            }
     }

    compress               = true
    default_ttl            = 31536000
    max_ttl                = 31536000
    min_ttl                = 31536000
    path_pattern           = "new/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "fafcrrq1m1.execute-api.us-east-1.amazonaws.com"
    origin_id           = "origin-api-gdm-crf-getapp-stg"
    origin_path         = "/staging"

    custom_header {
      name  = "x-gdm-source-site"
      value = "GetApp"
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
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "k8s-reviews.capstage.net"
    origin_id           = "k8s-reviews.capstage.net"

    custom_header {
      name  = "x-gdm-source-site"
      value = "GetApp"
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
    domain_name              = data.aws_s3_bucket.origin.bucket_domain_name
    origin_id                = "S3-central-review-form-stg/assets"
    origin_path              = "/assets"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = data.aws_s3_bucket.origin.bucket_domain_name
    origin_id                = "origin-s3-gdm-crf-getapp-stg"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = data.aws_s3_bucket.origin_cdn.bucket_domain_name
    origin_id                = "S3-crf-getapp-staging-cdn"
    origin_access_control_id = var.cf_origin_access_control
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:350125959894:certificate/ad857ea6-1839-42f0-a101-b79e9c2ff83d"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
