resource "aws_cloudfront_distribution" "s3_distribution" {
  comment    = "Staging CRF - UpCity"
  aliases    = ["reviews.staging.upcity.com"]
  web_acl_id = data.aws_wafv2_web_acl.crf.arn

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
    response_code         = "404"
    response_page_path    = "/new/404"
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

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-SmartTV-Viewer"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "origin-api-gdm-crf-upcity-stg"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer"]
      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-upcity-stg"
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
    target_origin_id       = "S3-gdm-crf-upcity-stg"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["OPTIONS", "GET", "DELETE", "HEAD", "PATCH", "PUT", "POST"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
      query_string = "false"
    }

    path_pattern           = "static/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer", "Authorization"]
      query_string = "true"
    }

    path_pattern           = "k8s/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    path_pattern           = "_next/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-upcity-stg"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
      query_string = "true"
    }

    path_pattern           = "search*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
    viewer_protocol_policy = "redirect-to-https"
  }
  

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "false"

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    path_pattern           = "storybook/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-crf-upcity-stg"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer"]
      query_string = "true"
    }

    path_pattern           = "providers/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
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

      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer"]
      query_string = "true"
    }

    path_pattern           = "validate/*"
    smooth_streaming       = "false"
    target_origin_id       = "k8s-reviews.capstage.net"
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
      headers      = ["CloudFront-Is-SmartTV-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-IOS-Viewer", "CloudFront-Is-Android-Viewer"]
      query_string = "true"
    }

    path_pattern           = "products/*"
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
    path_pattern           = "fsrelay/*"
    smooth_streaming       = false
    target_origin_id       = "k8s-reviews.capstage.net"
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.custom.id
  }
  
  ordered_cache_behavior {
    allowed_methods = ["HEAD" , "GET"]
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
    target_origin_id       = "S3-gdm-crf-upcity-stg"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name              = data.aws_s3_bucket.origin.bucket_domain_name
    origin_id                = "origin-s3-gdm-crf-upcity-stg"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name              = data.aws_s3_bucket.origin.bucket_domain_name
    origin_id                = "S3-central-review-form-stg/assets"
    origin_path              = "/assets"
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name              = data.aws_s3_bucket.origin_cdn.bucket_domain_name
    origin_id                = "S3-gdm-crf-upcity-stg"
    origin_access_control_id = var.cf_origin_access_control
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
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "fafcrrq1m1.execute-api.us-east-1.amazonaws.com"
    origin_id   = "origin-api-gdm-crf-upcity-stg"
    origin_path = "/staging"
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
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "k8s-reviews.capstage.net"
    origin_id   = "k8s-reviews.capstage.net"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:350125959894:certificate/51a6afaa-3257-48f9-930d-ea113796eff6"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}


