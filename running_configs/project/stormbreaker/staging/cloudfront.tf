resource "aws_cloudfront_distribution" "cf_stormbreaker" {
  enabled         = true
  aliases         = ["${local.subdomain_name}.${local.domain_name}"]
  is_ipv6_enabled = true
  comment         = "Cloudfront distribution for ${var.application}"
  price_class     = "PriceClass_200"

  origin {
    domain_name              = aws_s3_bucket.s3_stormbreaker.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3_stormbreaker.id
    origin_path              = ""
    origin_access_control_id = var.cf_origin_access_control
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.s3_stormbreaker.id
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_uri.arn
    }

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 31536000

  }

  logging_config {
    include_cookies = "false"
    bucket          = "${aws_s3_bucket.s3_stormbreaker.id}.s3.amazonaws.com"
    prefix          = "logging-cf-${var.application}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    ignore_changes = [
      tags,
      tags_all,
      origin
    ]
  }

  depends_on = [aws_acm_certificate_validation.certvalidation]
}

resource "aws_cloudfront_function" "rewrite_uri" {
  name    = "rewrite-request-${var.application}"
  runtime = "cloudfront-js-1.0"
  comment = "stormbraker rewrite request"
  publish = true
  code    = file("${path.module}/src/function.js")
}

#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  provider = aws.route53_account

  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "CNAME"
  name    = "${local.subdomain_name}.${local.domain_name}"
  ttl     = 90
  records = [aws_cloudfront_distribution.cf_stormbreaker.domain_name]
}
