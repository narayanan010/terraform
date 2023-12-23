# This module should:
  ## Add CF distro.
	##  Create Cloudfront Distribution with:-
			### Default Cache Behavior
			### Also creates 1 origin S3
	## Create DNS record in appropriate Hosted zone to point to the cloudfront distribution.

#*************************************************************************************************************************************************************#
#                                                                     PROVIDER DATA                                                                           #
#*************************************************************************************************************************************************************#
#Moving provider info from provider.tf to main.tf
terraform {
  required_providers {
    aws = {
      source                    = "hashicorp/aws"
      version                   = ">= 4.40.0"
      configuration_aliases = [ 
        aws.primary_cf_account,
        aws.route53_account,
       ]
    }
  }
  required_version = ">= 1.1.0"
}

#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}

#*************************************************************************************************************************************************************#
#                                                         ACM CERTIFICATE SECTION WITH VALIDATION INCLUDED                                                    #
#*************************************************************************************************************************************************************#
#Note: This section will use multiple provider info. Because ACM cert accounts and R53 Hosted Zone accounts can be different AWS Accounts. Use valid Providers.


#This section will create acm certificate in the account that will host Cloudfront distribution. This has to run in the account that will host CF Distro.
#Use Valid provider.
resource "aws_acm_certificate" "cert" {
  provider = aws.primary_cf_account
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_type

  tags = {
    Name              = var.cert_domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

#This section will create CNAME record for Cert Validation in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
resource "aws_route53_record" "cert_validation" {
  provider = aws.route53_account
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  #zone_id = "${data.aws_route53_zone.zone.id}"
  zone_id = var.hosted_zone_id
  ttl     = 60
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  provider = aws.primary_cf_account
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


#*************************************************************************************************************************************************************#
#                      							   AWS CLOUDFRONT SECTION WITH ALL SETTINGS FOR SERVERLESS APP INCLUDED       		                          #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.primary_cf_account
  web_acl_id = var.waf_required ? var.web_acl_arn : null

  # Wait for resources and associations to be created; Added this as creation of ACM cert and using it immediately after creation in CF was reporting errors in viewer_certificate block. So added depends_on
  depends_on = [
      aws_acm_certificate_validation.cert
   ]

  origin {
    domain_name = "${var.bucketname}.s3.amazonaws.com"
    origin_id   = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    origin_path = "${var.origin_path}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is for hosting of serverless app named- ${var.name}"
  default_root_object = "${var.cf_default_root_object}"

  #aliases = "${var.cf_aliases}"
  #aliases = ["${split(",", element(var.cf_aliases, count.index))}"]
  aliases = concat([var.cert_domain_name], var.cf_aliases)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    compress = true

    forwarded_values {
      query_string = "${var.cf_forward_query_string_api}"
      #Uncomment the <headers> below to add the whitelisted header to default_cache_behavior under <Cache Based on Selected Request Headers: Whitelist> value in Cloudfront. And pass list of headers to variable "cf_forward_header_values" while calling module. Or else <Cache Based on Selected Request Headers: None> is set.
      #headers      = var.cf_forward_header_values
	  cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.cf_viewer_protocol_policy}"
    min_ttl                = "${var.custom_min_ttl}"
    default_ttl            = "${var.custom_default_ttl}"
    max_ttl                = "${var.custom_max_ttl}"
  }

  price_class = "${var.cf_price_class}"

  restrictions {
      geo_restriction{
          restriction_type = "none"
      }    
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "${var.cf_minimum_protocol_version}"
  }
}

#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  provider  =   aws.route53_account
  #zone_id   =   "${data.aws_route53_zone.zone.id}"
  zone_id   = var.hosted_zone_id
  type      =   "CNAME"
  name      =   "${var.cert_domain_name}"
  ttl       =   "${var.r53_dns_ttl}"
  records   =   ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
}