resource "aws_cloudfront_distribution" "sem-ui-prod-E2NTTUAKIRGN2F" {
  provider = aws
  aliases  = ["sem-ui-prd.capterra.com"]
  comment  = "This is for hosting of serverless app named- sem-ui-prd"

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["Referer"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "origin-api-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "false"

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = "false"
    prefix          = "296947561675/E2NTTUAKIRGN2F"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semCompare/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "semCompare/semCompareStatic/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semDisplay/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semSearch/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semCompareMobile/semCompareMobileStatic/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semCompareMobile/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semCompareServicesMobile/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semCompareServices/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
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
    path_pattern           = "semPPL/assets/*"
    smooth_streaming       = "false"
    target_origin_id       = "origin-s3-gdm-sem-ui-prd-capterra-production"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1"]
    }

    domain_name = "xmfxaad7u0.execute-api.us-east-1.amazonaws.com"
    origin_id   = "origin-api-gdm-sem-ui-prd-capterra-production"
    origin_path = "/prod"
  }

  origin {
    connection_attempts      = "3"
    connection_timeout       = "10"
    domain_name              = "sem-ui-prd.s3.amazonaws.com"
    origin_id                = "origin-s3-gdm-sem-ui-prd-capterra-production"
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  tags = {
    Environment         = "production"
    app_component       = "capterra"
    app_contacts        = "capterra_devops"
    app_environment     = "staging"
    application         = "sem-ui"
    business_unit       = "gdm"
    created_by          = "sarvesh.gupta/colin.taras@gartner.com"
    environment         = "production"
    function            = "cache-cdn"
    monitoring          = "false"
    network_environment = "prod"
    product             = "sem-ui"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }

  tags_all = {
    Environment         = "production"
    app_component       = "capterra"
    app_contacts        = "capterra_devops"
    app_environment     = "staging"
    application         = "sem-ui"
    business_unit       = "gdm"
    created_by          = "sarvesh.gupta/colin.taras@gartner.com"
    environment         = "production"
    function            = "cache-cdn"
    monitoring          = "false"
    network_environment = "prod"
    product             = "sem-ui"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:296947561675:certificate/806530e5-2d6e-4477-8d2a-1b60a14b17f1"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = "arn:aws:wafv2:us-east-1:296947561675:global/webacl/capterra-sem-ui-prod-waf/cd6ea42c-5778-416c-abb8-913b3d157548"
}