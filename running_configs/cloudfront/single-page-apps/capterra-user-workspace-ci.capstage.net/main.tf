resource "aws_cloudfront_distribution" "EX1PQUUEWBRJL" {
  aliases             = ["capterra-user-workspace-ci.capstage.net"]
  comment             = "Cloudfront Distribution for User Workspace CI Environment"
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  web_acl_id          = "arn:aws:wafv2:us-east-1:148797279579:global/webacl/capterra-waf-acl-dev-glbl/c15738c6-0194-4f5c-be7a-8f9475ed04ea"

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 405
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 500
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 501
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 502
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 503
    response_code         = 0
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 504
    response_code         = 0
  }


  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"

    max_ttl                = "0"
    default_ttl            = "0"
    min_ttl                = "0"
    smooth_streaming       = false
    target_origin_id       = "capterra-user-workspace-ci-api-origin"
    viewer_protocol_policy = "redirect-to-https"
  }

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = false
    prefix          = "148797279579/EX1PQUUEWBRJL"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/workspace*"
    smooth_streaming       = false
    target_origin_id       = "origin-capterra-user-workspace-ci-s3"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::148797279579:function/spa_url_rewrite"
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/workspace/index.html"
    smooth_streaming       = false
    target_origin_id       = "origin-capterra-user-workspace-ci-s3"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "https-only"
  }

  origin {
    domain_name = "87uiitnx5f.execute-api.us-east-1.amazonaws.com"
    origin_id   = "capterra-user-workspace-ci-api-origin"
    origin_path = "/ci"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = "capterra-user-workspace-ci.s3.us-east-1.amazonaws.com"
    origin_id   = "origin-capterra-user-workspace-ci-s3"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:148797279579:certificate/b761d8fa-35d5-4c28-9f9e-4f65b6a22f12"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }

}


