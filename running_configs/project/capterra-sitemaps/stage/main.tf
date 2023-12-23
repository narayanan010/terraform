#*************************************************************************************************************************************************************#
#                                                      			   STATIC-WEBSITE-HOSTING SECTION		                                                      #
#*************************************************************************************************************************************************************#

resource "aws_s3_bucket" "cf_primary_bucket" {
  bucket   = "capterra-sitemap-stage"

  tags = module.tags_resource_module.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = "capterra-sitemap-stage"

  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
    bucket = aws_s3_bucket.cf_primary_bucket.id

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
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_type
  
  tags = module.tags_resource_module.tags

  lifecycle {
    create_before_destroy = true
  }
}


#This section will create CNAME record for Cert Validation in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
resource "aws_route53_record" "cert_validation" {

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
  zone_id         = "${data.aws_route53_zone.zone.zone_id}"
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

#*************************************************************************************************************************************************************#
#                      							   AWS CLOUDFRONT SECTION WITH ALL SETTINGS FOR SERVERLESS APP INCLUDED       		                          #
#*************************************************************************************************************************************************************#

#This section will create the OAC for the s3 origin.
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "sitemaps-oac"
  description                       = "OAC for Sitemaps"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [
    aws_acm_certificate_validation.cert
  ]

  origin {
    domain_name = "capterra-sitemap-stage.s3.amazonaws.com"
    origin_id   = "origin-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "This is for hosting of serverless app named- Sitemaps"

  aliases = concat([var.cert_domain_name], var.cf_aliases)
  price_class = var.cf_price_class
  web_acl_id = var.wafID

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl
    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    smooth_streaming       = false
    target_origin_id       = "origin-s3"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }

  restrictions {
      geo_restriction{
          restriction_type = "none"
      }    
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = var.cf_minimum_protocol_version
  }
}

data "aws_route53_zone" "zone" {
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}

#*************************************************************************************************************************************************************#
#                                                SECTION WITH POLICY ADDTION TO LIMIT ACCESS TO S3 ONLY VIA CLOUDFRONT                                        #
#*************************************************************************************************************************************************************#
#This section will use multiple provider info because primary and secondary buckets are in different regions per our requirements.
#For primary bucket, This section is for S3 policy creation to limit access to s3. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
data "aws_iam_policy_document" "s3_policy_primary_bucket" {

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
  depends_on = [aws_s3_bucket.cf_primary_bucket, aws_s3_bucket_public_access_block.block_public_access]
  bucket     = "capterra-sitemap-stage"
  policy     = data.aws_iam_policy_document.s3_policy_primary_bucket.json
}

#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  zone_id  = "${data.aws_route53_zone.zone.zone_id}"
  type     = "CNAME"
  name     = var.cert_domain_name
  ttl      = var.r53_dns_ttl
  records  = ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
}


#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  source                         = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"
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
}