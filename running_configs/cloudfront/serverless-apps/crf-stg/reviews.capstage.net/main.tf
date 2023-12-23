resource "aws_cloudfront_distribution" "tfer--EAZGRKOW2G7RF" {
  comment    = "Staging CRF - Capterra"
  aliases    = ["crf-stg.capstage.net"]
  web_acl_id = data.aws_wafv2_web_acl.crf.arn

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
    response_code         = "0"
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
    error_caching_min_ttl = "1"
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
     error_caching_min_ttl = 10 
     error_code            = 404
     response_code         = 0 
    }
  custom_error_response {
    error_caching_min_ttl = "1"
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

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "origin-api-gdm-crf-capterra-stg"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "false"

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = "false"
    prefix          = "350125959894/EAZGRKOW2G7RF"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Viewer-Country", "CloudFront-Viewer-Country-Region"]
      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-capterra-stg"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Viewer-Country", "CloudFront-Viewer-Country-Region"]
      query_string = "false"
    }

    max_ttl                = "86400"
    min_ttl                = "86400"
    path_pattern           = "cdn/*"
    smooth_streaming       = "false"
    target_origin_id       = "S3-crf-capterra-staging-cdn"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "86400"

    forwarded_values {
      cookies {
        forward = "all"
      }
      headers      = ["CloudFront-Is-Android-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Viewer-Country", "CloudFront-Viewer-Country-Region"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "0"
    path_pattern           = "static/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
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
    path_pattern           = "k8s/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "_next/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-crf-capterra-stg"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
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
    path_pattern           = "search*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    compress               = false
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "storybook/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-crf-capterra-stg"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
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
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    path_pattern           = "validate/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    path_pattern           = "products/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    path_pattern           = "validate-new/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    cache_policy_id        = aws_cloudfront_cache_policy.custom.id
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
    path_pattern           = "v/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
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
    target_origin_id       = "origin-api-gdm-crf-capterra-stg"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = aws_cloudfront_cache_policy.custom.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom.id
  }
 
   ordered_cache_behavior {
     allowed_methods        = [
              "DELETE",
              "GET",
              "HEAD",
              "OPTIONS",
              "PATCH",
              "POST",
              "PUT",
         ]
    cached_methods         = [
              "GET",
              "HEAD",
          ]
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
          allowed_methods        = [
              "GET",
              "HEAD",
            ]
          cached_methods         = [
              "GET",
              "HEAD",
            ] 
          compress               = true
          default_ttl            = 31536000
          max_ttl                = 31536000
          min_ttl                = 31536000
          path_pattern           = "robots.txt"
          smooth_streaming       = false
          target_origin_id       = "S3-crf-capterra-staging-cdn"
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
  origin {
    domain_name = "fafcrrq1m1.execute-api.us-east-1.amazonaws.com"
    origin_id   = "origin-api-gdm-crf-capterra-stg"
    origin_path = "/staging"

    custom_header {
      name  = "x-gdm-source-site"
      value = "Capterra"
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
    domain_name = "k8s-reviews.capstage.net"
    origin_id   = "k8s-reviews.capstage.net"

    custom_header {
      name  = "x-gdm-source-site"
      value = "Capterra"
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
    domain_name              = aws_s3_bucket.tfer--central-002D-review-002D-form-002D-stg.bucket_domain_name
    origin_id                = "S3-central-review-form-stg/assets"
    origin_path              = "/assets"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name              = aws_s3_bucket.tfer--central-002D-review-002D-form-002D-stg.bucket_domain_name
    origin_id                = "origin-s3-gdm-crf-capterra-stg"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name              = aws_s3_bucket.crf-staging-cdn.bucket_domain_name
    origin_id                = "S3-crf-capterra-staging-cdn"
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
    acm_certificate_arn            = "arn:aws:acm:us-east-1:350125959894:certificate/cdc201b8-a132-4990-a34f-e4ec42200bcb"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
