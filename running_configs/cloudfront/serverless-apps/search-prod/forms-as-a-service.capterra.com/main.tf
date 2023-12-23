resource "aws_cloudfront_distribution" "faas-prod" {
  aliases = ["forms-as-a-service.capterra.com"]

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = true
    prefix          = "296947561675/E3QU956TJD6URD/"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "400"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "502"
    response_code         = "0"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cache_policy_id        = aws_cloudfront_cache_policy.faas-prod-cache-policy.id
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = "false"
    default_ttl            = "0"
    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers                 = ["Origin"]
      query_string            = "true"
      query_string_cache_keys = ["pageCategory", "pagePlacement", "pageType", "pageVariant"]
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/form/*"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers                 = ["Origin"]
      query_string            = "true"
      query_string_cache_keys = ["pageCategory", "pagePlacement", "pageType", "pageVariant"]
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/modal/*"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/faas-modal-payload.js"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers                 = ["Origin"]
      query_string            = "true"
      query_string_cache_keys = ["formId"]
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "/preview"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = aws_cloudfront_cache_policy.faas-prod-cache-policy.id
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = "false"
    default_ttl            = "0"
    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "/faas-preview-payload.js"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Viewer-City", "CloudFront-Viewer-Country-Name", "Origin", "User-Agent", "X-Forwarded-For"]
      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "/api/form/submit"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/faas-payload.js"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    path_pattern           = "/linkedin"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers                 = ["CloudFront-Is-Desktop-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Tablet-Viewer", "CloudFront-Viewer-Country", "Origin", "User-Agent"]
      query_string            = "true"
      query_string_cache_keys = ["pageCategory", "pagePlacement", "pageType", "pageVariant"]
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/ab-test/*"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/modal-payload/*"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = "false"
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/inline-payload/*"
    smooth_streaming       = "false"
    target_origin_id       = "FAAS ApiGateway"
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
      origin_ssl_protocols     = ["TLSv1.2"]
    }

    domain_name = "ox7ajs8onl.execute-api.us-east-1.amazonaws.com"
    origin_id   = "FAAS ApiGateway"
    origin_path = "/prod"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:296947561675:certificate/39f27660-9746-47d5-9828-d13bc4ed24c5"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = "arn:aws:wafv2:us-east-1:296947561675:global/webacl/capterra-forms-as-a-service-prod-waf/447cebca-4777-44aa-93b8-c03978cde4e2"
}
