# This config will:
	##  Create Cloudfront Distribution with:-
			### Origin to vp-frontend-staging bucket
			### Origin access identity


#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


#*************************************************************************************************************************************************************#
#                                                               AWS CLOUDFRONT SECTION WITH ALL SETTINGS                                                      #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = var.s3_regional_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = var.oai_id
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is for hosting for vp-frontend-staging"

  #logging_config {
    #include_cookies = false
    #bucket          = "logs.s3.amazonaws.com"
    #prefix          = "prefix"
  #}

  aliases = var.cf_alias

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD" , "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "origin-s3-vp-frontend-staging"
    compress = true

    forwarded_values {
      query_string = var.cf_forward_query_string
      headers      = var.cf_forward_header_values
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cf_viewer_protocol_policy
    min_ttl                = var.custom_min_ttl
    default_ttl            = var.custom_default_ttl
    max_ttl                = var.custom_max_ttl
  }

  price_class = var.cf_price_class

  restrictions {
      geo_restriction{
          restriction_type = "none"
      }    
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = var.cf_minimum_protocol_version
  }

  web_acl_id = var.waf_acl_arn
}

#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  zone_id   = var.hosted_zone_id
  type      =   "CNAME"
  name      =   "${var.acm_cert_domain}"
  ttl       =   "${var.r53_dns_ttl}"
  records   =   ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
}