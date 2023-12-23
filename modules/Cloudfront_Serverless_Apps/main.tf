# This module should:
  ## Get the value of S3 bucket details, API Gateway endpoints and other related information from CloudFormation templates.
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
#Moving provider info from provider.tf to main.tf
provider "aws" {
   alias =  "primary_cf_account"
   #region = var.region_aws
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 }

provider "aws" {
  alias = "route53_account"
  #region = var.region_aws
  #Uncomment below to test module while development
  #assume_role {
  #Below Role is Capterra account Role. This can be replaced with any assume Role info
  #     role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/assume-capterra-admin-batch"
  #}
}

 #provider "aws" {
   #alias =  "dest"
   #region = "${var.dest_region}"
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 #}

 #This is needed, as the latest providers have bug and continue prompting for region even though defined under specific alias. https://github.com/terraform-providers/terraform-provider-aws/issues/9989
 #provider "aws" {
   #region = var.region_aws
 #}


#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


#*************************************************************************************************************************************************************#
#                                                        	 GET CLOUDFORMATION OUTPUTS VIA DATASOURCE                        		                          #
#*************************************************************************************************************************************************************#

data "aws_cloudformation_stack" "serverless_stack" {
  provider = aws.primary_cf_account
  name = var.cloudformationstackname
}


#*************************************************************************************************************************************************************#
#                                                      			   STATIC-WEBSITE-HOSTING SECTION		                                                      #
#*************************************************************************************************************************************************************#

resource "aws_s3_bucket" "cf_primary_bucket" {
  provider = aws.primary_cf_account
  bucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
  acl = "public-read"
  tags = {
    Environment  =  var.stage
    Product      =  var.name
    vertical    =   var.vertical
    terraform_managed   =   "true"
    #value_from_stack = "${data.aws_cloudformation_stack.serverless_stack.outputs["SpotinstRoleArn"]}"
    value_from_stack = "${data.aws_cloudformation_stack.serverless_stack.outputs[var.cloudformation_stack_output_endpoint_variable]}"
    }
  website {
    index_document = var.cf_primary_bucket_index_doc
    error_document = var.cf_primary_bucket_error_doc
    }
  versioning {
    enabled = false
    }

  #server_side_encryption_configuration {
    #rule {
      #apply_server_side_encryption_by_default {
        #sse_algorithm = "AES256"
      #}
    #}
  #}
    
  #replication_configuration {
    #role = "${aws_iam_role.replication.arn}"
    #rules {
      #id     = "Rule1"
      #priority = 1
      #prefix = ""
      #status = "Enabled"
      #destination {
        #bucket        = "${aws_s3_bucket.cf_secondary_bucket.arn}"
        #storage_class = "STANDARD"
      #}
    #}
  #}
}


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
    terraform_managed = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#This section will fetch info needed for Creation of CNAME record for DNS validation required for acm certificate. This has to run in the account that hosts R53 Hosted-Zone. Use valid Provider.
#While testing the module from here, below data "aws_route53_zone" worked fine. But while calling module from outside resulted in error that "NoR53 Zone found". Hence data section has to be moved to outside resource manifest that calls module. Reference : https://issue.life/questions/41631966 . Hence commenting below section. To test module locally uncomment.
#data "aws_route53_zone" "zone" {
#  provider = aws.route53_account
#  #name         = "capstage.net."
#  name          = var.cert_hosted_zone_name
#  private_zone = false
#}

#This section will create CNAME record for Cert Validation in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
resource "aws_route53_record" "cert_validation" {
  provider = "aws.route53_account"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  #zone_id = "${data.aws_route53_zone.zone.id}"
  zone_id = var.hosted_zone_id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  provider = aws.primary_cf_account
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
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
      "aws_acm_certificate_validation.cert"
   ]

  origin {
    domain_name = "${aws_s3_bucket.cf_primary_bucket.bucket_regional_domain_name}"
    origin_id   = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  origin {
    #This expects the Cloudformation Stack output Variable value in format as: https://{url}/{api-stage} ; to deduce domain_name and origin_path automatically. Eg: https://iqaegi32g2.execute-api.us-east-1.amazonaws.com/sandbox
    domain_name = element(split("/", "${data.aws_cloudformation_stack.serverless_stack.outputs[var.cloudformation_stack_output_endpoint_variable]}"),2)
	origin_id   = "origin-api-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    origin_path = format("/%s",element(split("/", "${data.aws_cloudformation_stack.serverless_stack.outputs[var.cloudformation_stack_output_endpoint_variable]}"),3))

    custom_origin_config {
      http_port = var.custom_origin_config_api-http_port
      https_port = var.custom_origin_config_api-https_port
      origin_protocol_policy = var.custom_origin_config_api-origin_protocol_policy 
      origin_ssl_protocols = var.custom_origin_config_api-origin_ssl_protocols
      origin_keepalive_timeout = var.custom_origin_config_api-origin_keepalive_timeout
      origin_read_timeout = var.custom_origin_config_api-origin_read_timeout
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is for hosting of serverless app named- ${var.name}"
  #default_root_object = "${var.cf_default_root_object}"

  #aliases = "${var.cf_aliases}"
  #aliases = ["${split(",", element(var.cf_aliases, count.index))}"]
  aliases = concat([var.cert_domain_name], var.cf_aliases)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-api-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
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

  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    default_ttl     = var.ordered_cache_behavior_default_ttl

    forwarded_values {
      query_string = "${var.cf_forward_query_string}"
      cookies {
        forward = "none"
      }
	}

    max_ttl                = var.ordered_cache_behavior_max_ttl
    min_ttl                = var.ordered_cache_behavior_min_ttl
    path_pattern           = var.s3_path_pattern
    smooth_streaming       = false
    target_origin_id       = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy
  }

  price_class = "${var.cf_price_class}"

  restrictions {
      geo_restriction{
          restriction_type = "none"
      }    
  }


  custom_error_response {
      error_code = "403"
      error_caching_min_ttl  = "${var.cf_error_caching_min_ttl}"
      response_code = "${var.cf_response_code}"
      response_page_path = "${var.cf_response_page_path}"
    }

  custom_error_response {
      error_code = "404"
      error_caching_min_ttl  = "${var.cf_error_caching_min_ttl}"
      response_code = "${var.cf_response_code}"
      response_page_path = "${var.cf_response_page_path}"
    }


  tags = {
    Environment         =  "${var.stage}"
    Product             =  "${var.name}"
    vertical            =   "${var.vertical}"
    terraform_managed   =   "true" 
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "${var.cf_minimum_protocol_version}"
  }

  logging_config {
      include_cookies = "false"
      bucket          = "${aws_s3_bucket.cf_log_bucket.bucket_domain_name}"
      prefix          = "${var.name}-${var.vertical}-log"
    }
}



#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = "aws.primary_cf_account"
  comment = "OAI for serverless app named- ${var.name}"
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

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.cf_primary_bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3bp_primary_bucket" {
  provider = aws.primary_cf_account
  bucket = "${aws_s3_bucket.cf_primary_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy_primary_bucket.json}"
}


#*************************************************************************************************************************************************************#
#                                              					 LOG BUCKET CREATION FOR CLOUDFRONT DISTRIBUTION                   			                  #
#*************************************************************************************************************************************************************#

resource "aws_s3_bucket" "cf_log_bucket" {
provider = aws.primary_cf_account
  bucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}-log"
  #acl = "private"
  tags = {
    Environment  =  "${var.stage}"
    Product      =  "${var.name}"
    vertical    =   "${var.vertical}"
    terraform   =   "true"
    }
    lifecycle_rule {
      id = "log_rule"
      tags = {
        Environment  =  "${var.stage}"
        Product      =  "${var.name}"
        vertical    =   "${var.vertical}"
        Terraform   =   "true"
        AutoClean   =   "true" 
        } 
      enabled = "true"
      expiration {
        days = 90
      }      
    }
    #This is for giving cloudfront AWS Account `awslogsdelivery` access to the Cloudfront Bucket for log writing
   grant {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = var.aws_cf_log_account_canonical_id
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