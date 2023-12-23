# This module should:
	## Create S3 bucket with static web hosting enabled and replication to a bucket in us-west-2.
	## Create Amazon certificate.
	##  Create Cloudfront Distribution with:-
			### Error page redirecting 404 and 403 errors to index.html
			### Origin access identity
			### Origin group pointing to the replicated bucket from item 1 above.
	## Create DNS record in appropriate Hosted zone to point to the cloudfront distribution.


#*************************************************************************************************************************************************************#
#                                                                     PROVIDER DATA                                                                           #
#*************************************************************************************************************************************************************#
#Moving provider info from provider.tf to main.tf
provider "aws" {
   alias =  "primary_cf_account"
   #region = "${var.source_region}"
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 }

 provider "aws" {
   alias =  "dest"
   #region = "${var.dest_region}"
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 }

provider "aws" {
  alias = "route53_account"
  #region = "${var.source_region}"
  #Uncomment below to test module while development
  #assume_role {
  #Below Role is Capterra account Role. This can be replaced with any assume Role info
  #     role_arn     = "arn:aws:iam::xxxxxxxxxxxxxxxxxx:role/assume-capterra-admin-batch"
  #}
}


#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}

#*************************************************************************************************************************************************************#
#                                                         STATIC-WEBSITE-HOSTING SECTION WITH REPLICATION                                                     #
#*************************************************************************************************************************************************************#

#This S3 will be used as Primary origin in Cloudfront Origin-Group. It has Static Hosting, XRegion-Replication , Versioning (Cross Region Replication requires Versioning)

resource "aws_s3_bucket" "cf_primary_bucket" {
  provider = "aws.primary_cf_account"
  bucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
  acl = "private"
  tags = {
    Environment  =  "${var.stage}"
    Product      =  "${var.name}"
    vertical    =   "${var.vertical}"
    terraform_managed   =   "true"
    }
  website {
    index_document = "${var.cf_primary_bucket_index_doc}"
    error_document = "${var.cf_primary_bucket_error_doc}"
    }
  versioning {
    enabled = true
    }
  replication_configuration {
    role = "${aws_iam_role.replication.arn}"
    rules {
      id     = "Rule1"
      priority = 1
      prefix = ""
      status = "Enabled"
      destination {
        bucket        = "${aws_s3_bucket.cf_secondary_bucket.arn}"
        storage_class = "STANDARD"
      }
    }
  }
}

#This S3 will be used as secondary origin in Cloudfront Origin-Group. It has Static Hosting, Versioning enabled. This Secondary bucket will be replicated from Primary Bucket
resource "aws_s3_bucket" "cf_secondary_bucket" {
  provider      = "aws.dest"
  bucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"
  region = "${var.dest_region}"
  acl = "private"
  tags = {
    Environment  =  "${var.stage}"
    Product      =  "${var.name}"
    vertical    =   "${var.vertical}"
    terraform_managed   =   "true"
    }
  website {
    index_document = "${var.cf_secondary_bucket_index_doc}"
    error_document = "${var.cf_secondary_bucket_error_doc}"
    }
  versioning {
    enabled = true
    }
  }

#This section is for IAM role creation for XRegion Replication of primary bucket to secondary bucket
resource "aws_iam_role" "replication" {
  provider = "aws.primary_cf_account"
  #name = "S3_xRR_${var.namespace}-${var.name}-${var.vertical}-${var.stage}_to_${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"
  #Name changed to below syntax to overcome IAM Role 64 character limitation
  name = "S3_xRR_${var.name}-${var.stage}_to_${var.name}-${var.stage}-dr"
  tags = {
    sourcebucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    destinationbucket = "${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"
    terraform_managed = "true"
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

#This section is for IAM policy creation for XRegion Replication of primary bucket to secondary bucket
resource "aws_iam_policy" "replication" {
  provider = "aws.primary_cf_account"
  name = "s3crr_policy_for_${var.namespace}-${var.name}-${var.vertical}-${var.stage}_to_${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.cf_primary_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.cf_primary_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.cf_secondary_bucket.arn}/*"
    }
  ]
}
POLICY
}

#This section is for IAM policy attachment to IAM role for XRegion Replication and is used in Primary bucket Replication Role configuration
resource "aws_iam_role_policy_attachment" "replication" {
  provider = "aws.primary_cf_account"
  role       = "${aws_iam_role.replication.name}"
  policy_arn = "${aws_iam_policy.replication.arn}"
}



#*************************************************************************************************************************************************************#
#                                                         ACM CERTIFICATE SECTION WITH VALIDATION INCLUDED                                                    #
#*************************************************************************************************************************************************************#
#Note: This section will use multiple provider info. Because ACM cert accounts and R53 Hosted Zone accounts can be different AWS Accounts. Use valid Providers.


#This section will create acm certificate in the account that will host Cloudfront distribution. This has to run in the account that will host CF Distro Use Valid provider.
resource "aws_acm_certificate" "cert" {
  provider = "aws.primary_cf_account"
  domain_name       = "${var.cert_domain_name}"
  validation_method = "${var.cert_validation_type}"

  tags = {
    Name              = "${var.cert_domain_name}"
    terraform_managed = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#This section will fetch info needed for Creation of CNAME record for DNS validation required for acm certificate. This has to run in the account that hosts R53 Hosted-Zone. Use valid Provider.
#While testing the module from here, below data "aws_route53_zone" worked fine. But while calling module from outside resulted in error that "NoR53 Zone found". Hence data section has to be moved to outside resource manifest that calls module. Reference : https://issue.life/questions/41631966 . Hence commenting below section. To test module locally uncomment.
#data "aws_route53_zone" "zone" {
#  provider = "aws.route53_account"
#  #name         = "capstage.net."
#  name          = "${var.cert_hosted_zone_name}"
#  private_zone = false
#}

#This section will create CNAME record in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
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
  provider = "aws.primary_cf_account"
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}



#*************************************************************************************************************************************************************#
#                                    AWS CLOUDFRONT SECTION WITH ALL SETTINGS FOR SPA INCLUDED (With Lambda@edge Integration)                                 #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = "aws.primary_cf_account"

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
    domain_name = "${aws_s3_bucket.cf_secondary_bucket.bucket_regional_domain_name}"
    origin_id   = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is for SPA hosting for app named- ${var.name}"
  default_root_object = "${var.cf_default_root_object}"

  #aliases = "${var.cf_aliases}"
  #aliases = ["${split(",", element(var.cf_aliases, count.index))}"]
  aliases = concat([var.cert_domain_name], var.cf_aliases)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origingroup-S3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    compress = true

    forwarded_values {
      query_string = "${var.cf_forward_query_string}"

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.cf_viewer_protocol_policy}"
    min_ttl                = "${var.custom_min_ttl}"
    default_ttl            = "${var.custom_default_ttl}"
    max_ttl                = "${var.custom_max_ttl}"

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.folder_index_redirect.qualified_arn
      include_body = false
    }
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


#Origin Group Section Below
  origin_group {
    origin_id = "origingroup-S3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}"
    }

    member {
      origin_id = "origin-s3-${var.namespace}-${var.name}-${var.vertical}-${var.stage}-dr"
    }
  }
}



#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = "aws.primary_cf_account"
  comment = "OAI for SPA app named- ${var.name}"
}


#*************************************************************************************************************************************************************#
#                                                SECTION WITH POLICY ADDTION TO LIMIT ACCESS TO S3 ONLY VIA CLOUDFRONT                                        #
#*************************************************************************************************************************************************************#
#This section will use multiple provider info because primary and secondary buckets are in different regions per our requirements.
#For primary bucket, This section is for S3 policy creation to limit access to s3. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
data "aws_iam_policy_document" "s3_policy_primary_bucket" {
  provider = "aws.primary_cf_account"
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
  provider = "aws.primary_cf_account"
  bucket = "${aws_s3_bucket.cf_primary_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy_primary_bucket.json}"
}


#For Secondary bucket, This section is for S3 policy creation to limit access to s3. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public). Use appropriate dest provider as secondary bucket is in xRegion (Cross).
data "aws_iam_policy_document" "s3_policy_secondary_bucket" {
  provider = "aws.dest"
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cf_secondary_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.cf_secondary_bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3bp_secondary_bucket" {
  provider = "aws.dest"
  bucket = "${aws_s3_bucket.cf_secondary_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy_secondary_bucket.json}"
}

#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.
resource "aws_route53_record" "dns_record" {
  provider  =   "aws.route53_account"
  #zone_id   =   "${data.aws_route53_zone.zone.id}"
  zone_id   = var.hosted_zone_id
  type      =   "CNAME"
  name      =   "${var.cert_domain_name}"
  ttl       =   "${var.r53_dns_ttl}"
  records   =   ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
}