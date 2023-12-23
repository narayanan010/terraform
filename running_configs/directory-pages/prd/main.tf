terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"
  }
}

resource "aws_acm_certificate" "dirpage_capterra_com_us_e_1" {
  domain_name = "directory-page.capterra.com"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  tags              {}
  validation_method = "DNS"
}


resource "aws_cloudfront_distribution" "dirpage_cf" {
  aliases = ["directory-page.capterra.com"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = false
    target_origin_id       = "origin-api-gdm-directory-pages-capterra-prd"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/directoryPage/assets/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-directory-pages-capterra-prd"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/buyersGuide/assets/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-directory-pages-capterra-prd"
    viewer_protocol_policy = "HTTPS only"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "/common/assets/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-directory-pages-capterra-prd"
    viewer_protocol_policy = "HTTPS only"
  }

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = "31536000"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    max_ttl                = "31536000"
    min_ttl                = "31536000"
    path_pattern           = "robots.txt"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-gdm-vendor-pages-capterra-prd-robots"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = "directory-page-ui-prd.s3.amazonaws.com"
    origin_id   = "origin-s3-gdm-directory-pages-capterra-prd"
  }

  origin {
    domain_name = "directory-page-ui-prd.s3.amazonaws.com"
    origin_id   = "origin-s3-gdm-vendor-pages-capterra-prd-robots"
    origin_path = "/directoryPage/assets"
  }

  origin {
    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "1sjhzakrya.execute-api.us-east-1.amazonaws.com"
    origin_id   = "origin-api-gdm-directory-pages-capterra-prd"
    origin_path = "/prod"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = false
  tags             {}

  viewer_certificate {
    acm_certificate_arn            = "${aws_acm_certificate.dirpage_capterra_com_us_e_1.arn}"

    #acm_certificate_arn            = "arn:aws:acm:us-east-1:296947561675:certificate/189e6db4-ecd7-42b5-b701-d63f3207962c"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }

  wait_for_deployment = true
  web_acl_id          = "d8a6a5b8-98c3-464f-9e34-ae50a6783cc4"
}
