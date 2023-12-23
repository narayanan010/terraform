# This module is forked from Capterra in-house TF module for "Cloudfront_Serverless_Apps". This is modified specifically for capterra-User-Workspace requirements.
# This module should:
## Get the value of API Gateway endpoints and other related information from CloudFormation templates.
## 
## 
##  Create Cloudfront Distribution with:-
### Error page redirecting 404 and 403 errors to index.html
### Origin access identity
### Default Cache Behavior and One ordered Cache Behavior
### Also creates 2 origins one for S3 and another for API Gateway.
## Create DNS record in appropriate Hosted zone to point to the cloudfront distribution.

#*************************************************************************************************************************************************************#
#                                                                     PROVIDER DATA                                                                           #
#*************************************************************************************************************************************************************#
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.primary_cf_account, aws.route53_account]
    }
  }
}

#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_cloudformation_stack" "network" {
  provider = aws.primary_cf_account
  name     = var.cloudformationstackname
}

#*************************************************************************************************************************************************************#
#                                                      			   STATIC-WEBSITE-HOSTING SECTION		                                                      #
#*************************************************************************************************************************************************************#

resource "aws_s3_bucket" "cf_primary_bucket" {
  provider = aws.primary_cf_account
  bucket   = var.primary_s3_bucket
  tags = {
    Environment       = var.stage
    Product           = var.name
    vertical          = var.vertical
    terraform_managed = "true"
  }
  force_destroy = true
}

resource "aws_s3_bucket_acl" "cf_primary_bucket_acl" {
  provider = aws.primary_cf_account

  bucket = aws_s3_bucket.cf_primary_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  provider = aws.primary_cf_account
  bucket   = aws_s3_bucket.cf_primary_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#*************************************************************************************************************************************************************#
#                                                         ACM CERTIFICATE SECTION WITH VALIDATION INCLUDED                                                    #
#*************************************************************************************************************************************************************#
#Note: This section will use multiple provider info. Because ACM cert accounts and R53 Hosted Zone accounts can be different AWS Accounts. Use valid Providers.


#This section will create acm certificate in the account that will host Cloudfront distribution. This has to run in the account that will host CF Distro.
#Use Valid provider.
resource "aws_acm_certificate" "cert" {
  provider          = aws.primary_cf_account
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_type

  tags = {
    Name              = var.cert_domain_name
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
      tags_all
    ]
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

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.primary_cf_account
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


#*************************************************************************************************************************************************************#
#                      							   AWS CLOUDFRONT SECTION WITH ALL SETTINGS FOR SERVERLESS APP INCLUDED       		                          #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.primary_cf_account

  # Wait for resources and associations to be created; Added this as creation of ACM cert and using it immediately after creation in CF was reporting errors in viewer_certificate block. So added depends_on
  depends_on = [
    aws_acm_certificate_validation.cert
  ]

  origin {
    domain_name = "${var.primary_s3_bucket}.${var.primary_s3_bucket_domainsuffix}"
    origin_id   = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    #origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_access_control_id = var.cf_origin_access_control
  }

  origin {
    domain_name = element(split("/", "${data.aws_cloudformation_stack.network.outputs[var.cloudformation_stack_output_endpoint_variable]}"), 2)
    origin_id   = "api-${var.name}-${var.stage}"
    origin_path = format("/%s", element(split("/", "${data.aws_cloudformation_stack.network.outputs[var.cloudformation_stack_output_endpoint_variable]}"), 3))

    custom_origin_config {
      http_port                = var.custom_origin_config_api-http_port
      https_port               = var.custom_origin_config_api-https_port
      origin_protocol_policy   = var.custom_origin_config_api-origin_protocol_policy
      origin_ssl_protocols     = var.custom_origin_config_api-origin_ssl_protocols
      origin_keepalive_timeout = var.custom_origin_config_api-origin_keepalive_timeout
      origin_read_timeout      = var.custom_origin_config_api-origin_read_timeout
    }

  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "This is for hosting of serverless app named- ${var.name}"

  aliases     = concat([var.cert_domain_name], var.cf_aliases)
  price_class = var.cf_price_class

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_default
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    smooth_streaming       = false
    target_origin_id       = "api-${var.name}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_standard
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = "workspace/rest/*"
    smooth_streaming       = false
    target_origin_id       = "api-${var.name}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_standard
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = "workspace/index.html"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_standard
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = "workspace/assets/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_standard
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = "workspace/mf-sandbox*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  ordered_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    cache_policy_id        = var.cache_policy_redirect_lambda
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = "workspace/*"
    smooth_streaming       = false
    target_origin_id       = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  custom_error_response {
    error_code            = "403"
    error_caching_min_ttl = var.cf_error_caching_min_ttl
    response_code         = var.cf_response_code
    response_page_path    = var.cf_response_page_path
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = var.cf_error_caching_min_ttl
    response_code         = var.cf_response_code
    response_page_path    = var.cf_response_page_path
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.cf_minimum_protocol_version
  }

  lifecycle {
    ignore_changes = [
      tags,
      tags_all,
    ]
  }

}

# This section contains the available cache policies
data "aws_cloudfront_cache_policy" "Managed-CachingOptimized" {
  provider = aws.primary_cf_account
  name     = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "Managed-CachingDisabled" {
  provider = aws.primary_cf_account
  name     = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "Managed-AllViewer" {
  provider = aws.primary_cf_account
  name     = "Managed-AllViewer"
}

data "aws_cloudfront_origin_request_policy" "Managed-CORS-S3Origin" {
  provider = aws.primary_cf_account
  name     = "Managed-CORS-S3Origin"
}


#*************************************************************************************************************************************************************#
#                                                SECTION WITH POLICY ADDTION TO LIMIT ACCESS TO S3 ONLY VIA CLOUDFRONT                                        #
#*************************************************************************************************************************************************************#
#This section will use multiple provider info because primary and secondary buckets are in different regions per our requirements.
#For primary bucket, This section is for S3 policy creation to limit access to s3. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
data "aws_iam_policy_document" "s3_policy_primary_bucket" {
  provider = aws.primary_cf_account

  statement {       # For OAC 
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cf_primary_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
			test     = "StringEquals"
			variable = "AWS:SourceArn"
			values   = [aws_cloudfront_distribution.s3_distribution.arn]
		}
  }
}


#Applying policy to override existing policy and allow access only via OAI
resource "aws_s3_bucket_policy" "s3bp_primary_bucket" {
  provider   = aws.primary_cf_account
  depends_on = [aws_s3_bucket.cf_primary_bucket, aws_s3_bucket_public_access_block.block_public_access]
  bucket     = var.primary_s3_bucket
  policy     = data.aws_iam_policy_document.s3_policy_primary_bucket.json
}



#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  provider = aws.route53_account
  zone_id  = var.hosted_zone_id
  type     = "CNAME"
  name     = var.cert_domain_name
  ttl      = var.r53_dns_ttl
  records  = [aws_cloudfront_distribution.s3_distribution.domain_name]
}
