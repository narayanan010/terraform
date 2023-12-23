# This module should:
## Create Cloudfront Distribution with:-
### Error page redirecting 404 and 403 errors to index.html
### Origin access identity
### Default Cache Behavior and One ordered Cache Behavior
### Also creates one origin for S3
## Create DNS record in appropriate Hosted zone to point to the cloudfront distribution.
## Create S3 bucket as the origin for the Cloudfront

#*************************************************************************************************************************************************************#
#                                                                     PROVIDER DATA                                                                           #
#*************************************************************************************************************************************************************#
#Moving provider info from provider.tf to main.tf
provider aws {
  alias = "primary_cf_account"
  #region = var.region_aws
  #Uncomment below to test module while development
  #assume_role {
  #Below Role is Sandbox account Role. This can be replaced with any assume Role info
  #  role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/no-color-staging-admin"
  #}
}

provider aws {
  alias = "route53_account"
  #region = var.region_aws
  #Uncomment below to test module while development
  #assume_role {
  #Below Role is Capterra account Role. This can be replaced with any assume Role info
  #     role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/assume-capterra-admin-batch"
  #}
}

#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


#*************************************************************************************************************************************************************#
#                                                      			   STATIC-WEBSITE-HOSTING SECTION		                                                      #
#*************************************************************************************************************************************************************#

resource "aws_s3_bucket" "cf_primary_bucket" {
  provider = aws.primary_cf_account
  bucket   = "${var.name}-${var.stage}-dr"
 
  website {
    index_document = var.cf_primary_bucket_index_doc
    error_document = var.cf_primary_bucket_error_doc
  }
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = module.tags_resource_module.tags
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://*.capstage.net",
                        "https://capstage.net",
                        "https://*.capterra.com",
                        "https://capterra.com"]
    expose_headers  = []
  }
}


#*************************************************************************************************************************************************************#
#                                                         ACM CERTIFICATE SECTION WITH VALIDATION INCLUDED                                                    #
#*************************************************************************************************************************************************************#
#Note: This section will use multiple provider info. Because ACM cert accounts and R53 Hosted Zone accounts can be different AWS Accounts. Use valid Providers.


#This section will create acm certificate in the account that will host Cloudfront distribution. This has to run in the account that will host CF Distro.
#Use Valid provider.
resource "aws_acm_certificate" "cert" {
  provider          = aws.primary_cf_account_ue1
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_type
  
  tags = module.tags_resource_module.tags

  lifecycle {
    create_before_destroy = true
  }
}


#This section will create CNAME record for Cert Validation in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
resource "aws_route53_record" "cert_validation" {
  provider = aws.route53_account
  name     = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type     = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id  = var.hosted_zone_id
  records  = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.primary_cf_account_ue1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}


#*************************************************************************************************************************************************************#
#                      							   AWS CLOUDFRONT SECTION WITH ALL SETTINGS FOR SERVERLESS APP INCLUDED       		                          #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.primary_cf_account

  tags = module.tags_resource_module.tags

  # Wait for resources and associations to be created; Added this as creation of ACM cert and using it immediately after creation in CF was reporting errors in viewer_certificate block. So added depends_on
  depends_on = [
    aws_acm_certificate_validation.cert
  ]

  origin {
    domain_name = aws_s3_bucket.cf_primary_bucket.bucket_regional_domain_name
    origin_id   = "s3-${var.name}-${var.stage}-dr"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "This is for hosting of serverless app named- ${var.name}"

  aliases = concat([var.cert_domain_name], var.cf_aliases)

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true
    default_ttl     = var.custom_default_ttl

    forwarded_values {
      query_string = var.cf_forward_query_string
      headers = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      cookies {
        forward = "none"
      }
    }

    max_ttl                = var.custom_max_ttl
    min_ttl                = var.custom_min_ttl
    smooth_streaming       = false
    target_origin_id       = "s3-${var.name}-${var.stage}-dr"
    viewer_protocol_policy = var.cf_viewer_protocol_policy
  }

  price_class = var.cf_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = "403"
    error_caching_min_ttl = var.cf_error_caching_min_ttl
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = var.cf_error_caching_min_ttl
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.cf_minimum_protocol_version
  }
  
  logging_config {
      include_cookies = "false"
      bucket          = "${var.cf_log_bucket_domain_name}"
      prefix          = "${data.aws_caller_identity.current.account_id}/${var.name}-${var.stage}-dr"
    }
}



#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = aws.primary_cf_account
  comment  = "OAI for serverless app named - ${var.name}"
}


#*************************************************************************************************************************************************************#
#                                                SECTION WITH POLICY ADDTION TO LIMIT ACCESS TO S3 ONLY VIA CLOUDFRONT                                        #
#*************************************************************************************************************************************************************#
#This section will use multiple provider info because primary and secondary buckets are in different regions per our requirements.
#For primary bucket, This section is for S3 policy creation to limit access to s3. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
data "aws_iam_policy_document" "s3_policy_primary_bucket" {
  provider = aws.primary_cf_account
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cf_primary_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3bp_primary_bucket" {
  provider = aws.primary_cf_account
  bucket   = aws_s3_bucket.cf_primary_bucket.id
  policy   = data.aws_iam_policy_document.s3_policy_primary_bucket.json
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block_primary_bucket" {
  provider = aws.primary_cf_account
  bucket = aws_s3_bucket.cf_primary_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
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
  records  = ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
}

#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  #source                         = "../../../tagging-resource-module"
  source                         = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"
  application                    = var.tag_application
  app_component                  = var.tag_app_component
  function                       = var.tag_function
  business_unit                  = var.tag_business_unit
  app_environment                = var.tag_app_environment
  app_contacts                   = var.tag_app_contacts
  created_by                     = var.tag_created_by
  system_risk_class              = var.tag_system_risk_class
  region                         = var.tag_region
  network_environment            = var.tag_network_environment             
  monitoring                     = var.tag_monitoring
  terraform_managed              = var.tag_terraform_managed
  vertical                       = var.tag_vertical
  product                        = var.tag_product
  environment                    = var.tag_environment

  #Add Other tags here that you want to apply to all resources, those are to be added to the resources apart from standard tags from Gartner/Capterra.
  tags = {
    "terraform_managed" = "true",
    "repository"        = "https://github.com/capterra/terraform.git"
  } 
}
