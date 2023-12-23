# Cloudfront module for SPA (Single Page App) for Capterra.
    This module is for creating CF distro for SPA.
    
#### What this module will do?
  ```
  # Create S3 bucket with static web hosting enabled and replication to a bucket in destination region (us-west-2).
  # Create Amazon certificate (ACM).
  # Will wait for ACM certificate to wait for to get to issued Status
  # Create Cloudfront Distribution with:-
      Error page redirecting 404 and 403 errors to index.html
      Origin access identity created
      Origin group pointing to the replicated bucket from item 1 above.
      Updating the bucket policies of primary and secondary bucket to restrict to OAI
      Automatically adds cert_domain_name to CNAME alias.
  # Create DNS record in appropriate Hosted zone to point to the cloudfront distribution created above.
  # Note: 
        * This module will accept single domain name for ACM cert. subject_alternative_names aren't supported due to current issue witn provider mentioned here: https://github.com/terraform-providers/terraform-provider-aws/issues/8531 . Future versions of module will support this functionality if needed for Non-SPA apps.
```

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account, 
        var.modulecaller_assume_role_dns_account
  3. Optionally backend section can be moved to backend.tf in caller manifest. Or Keep it as is.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly
  7. data "aws_route53_zone" "zone" {} section is included below, as this is needed to automatically deduce the zone_id required for CNAME record insertion in the hosted_zone during ACM validation via DNS method, and during the final CNAME creation that points to Created Cloudfront Domain. Keep it as is.


### Variables: 

There are 2 types of variables used here:   


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. Some of these are: 

* name -- name of application
* stage -- name of stage (dev/stg/prod/sandbox)
* vertical -- name of vertical (capterra/getapp/SA)
* dest_region -- region of secondary bucket i.e replica of primary bucket (default = us-west-2)
* source_region -- region of primary bucket (default = us-east-1)
* cert_hosted_zone_name -- Name of the Hosted Zone where the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g capstage.net.
* hosted_zone_id -- Route 53 hosted zone_id for domain_name.
* cert_domain_name -- This is certificate domain that needs to be whitelisted. Also used for the Name tag of the ACM certificate. This will also be added to CNAME alias in cloudfront automatically.  Format e.g spa-test.capstage.net
* r53_dns_ttl -- Route 53 record time-to-live (TTL) for validation record (default: 60).
* cf_forward_query_string -- Forward query string to the origin that is associated with this cache behavior. 
* cf_minimum_protocol_version -- The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018
* cf_default_root_object -- Default root object that CF Distro will point to.
* cf_viewer_protocol_policy -- Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https.
* cf_price_class -- The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100


2) The variables those needed in the calling manifest. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* s3_primary_bucket_id -- Name of the primary S3 bucket that serves as Source for xRegion Replication
* s3_primary_bucket_arn -- The Amazon Resource Name (ARN) of the Primary S3 bucket that serves as Source for xRegion Replication
* s3_secondary_bucket_id -- Name of the Secondary S3 bucket that serves as destination for xRegion Replication
* s3_secondary_bucket_arn -- The Amazon Resource Name (ARN) of the Secondary S3 bucket that serves as destination for xRegion Replication
* iam_role_arn -- The Amazon Resource Name (ARN) of the IAM Role created for S3 Replication
* iam_policy_arn -- The Amazon Resource Name (ARN) of the IAM Policy created for S3 Replication Role
* aws_acm_certificate_arn -- The Amazon Resource Name (ARN) of the ACM Certificate created for SPA (Single Page App)
* cloudfront_distro_id -- The ID of Cloudfront distribution just created for SPA (Single Page App)
* cloudfront_distro_arn -- The ARN of Cloudfront distribution just created for SPA (Single Page App)
* cloudfront_distro_domain_name -- The domain_name of Cloudfront distribution just created for SPA (Single Page App)
* cloudfront_OAI_id -- The ID of Cloudfront OAI just created for SPA (Single Page App)
* cloudfront_OAI_iam_arn -- The iam_arn of Cloudfront OAI just created for SPA (Single Page App)
* r53_dns_domain_name -- The name of DNS record just created for SPA (Single Page App)


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf
```
terraform {
  backend "s3" {
    bucket = "capterra-terraform-state"
    key    = "cloudfront-acm/cfr6/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table" 
  }
}

provider "aws" {
   alias =  "primary_cf_account"
     region = "${var.modulecaller_source_region}"
     assume_role {
       #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
       role_arn     = var.modulecaller_assume_role_primary_account
   }
 }

 provider "aws" {
   alias =  "dest"
     region = "${var.modulecaller_dest_region}"
     assume_role {
       #Below Role is Primary account Role with destination region different for secondary bucket. This can be replaced in var with any assume Role info. I used assume role from Sandbox
       role_arn     = var.modulecaller_assume_role_primary_account
   }
 }

provider "aws" {
  alias = "route53_account"
  region = "${var.modulecaller_source_region}"
  assume_role {
       #Below Role is R53 account Role. This can be replaced in variables with any assume Role info. I used assume role from Capterra
       role_arn     = var.modulecaller_assume_role_dns_account
   }
}

 provider "aws" {
   alias = "capterra-aws-admin"
   region = var.modulecaller_source_region
 }

 #Added this to fix "argument region not set error" while running plan. Bug in Provider.
 provider "aws" {
   region = var.modulecaller_source_region
 }

#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider = "aws.route53_account"
  #name         = "capstage.net."
  name          = "${var.modulecaller_dns_r53_zone}"
  private_zone = false
}

module "cf_dist" {
  source                         = "/Users/sargupta/Capterra-github/terraform/modules/cloudfront"
  name                           = "cfr5"
  stage                          = "sandbox"
  vertical                       = "capterra"
  cert_domain_name               = "spa-test5.capstage.net"
  cert_hosted_zone_name          = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  source_region                  = "us-east-1"
  dest_region                    = "us-west-2"
  #cf_aliases                    = ["spa-test9.capstage.net"]
  #cf_forward_query_string
  #cf_minimum_protocol_version
  #cf_default_root_object
  #cf_viewer_protocol_policy
  #cf_price_class
  
  providers = {
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.dest = "aws.dest"
    aws.route53_account = "aws.route53_account"
  }
}
```

#### Include Below section to caller's variables.tf, Replace values of all the variables with name beginning with modulecaller_xxxx
```
  variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

  variable "modulecaller_dest_region" {
  default = "us-west-2"
  description = "Region of Secondary Bucket that needs to be passed to Provider info where calling module"
}

  variable "modulecaller_dns_r53_zone" {
  default = "capstage.net."
  description = "Hosted Zone name Value to be passed to Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

  variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::944xxxxxx557:role/no-color-staging-admin"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets. Replace this value per need."
}

  variable "modulecaller_assume_role_dns_account" {
  default = "arn:aws:iam::176xxxxxx868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly). Replace this per need."
} 
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. cf_dist is the reference used while calling module. Sample Below-
```  
  output "cloudfront_distro_id" {
  value = "${module.cf_dist.cloudfront_distro_id}"
  description = "The ID of Cloudfront distribution just created for SPA (Single Page App)"  
}

  output "aws_acm_certificate_arn" {
  value = "${module.cf_dist.aws_acm_certificate_arn}"
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for SPA (Single Page App)"
}

  output "cloudfront_OAI_iam_arn" {
  value = "${module.cf_dist.cloudfront_OAI_iam_arn}"
  description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}

  output "r53_dns_domain_name" {
  value = "${module.cf_dist.r53_dns_domain_name}"
  description = "The name of DNS record just created for SPA (Single Page App)"
}

  output "s3_primary_bucket_id" {
  value = "${module.cf_dist.s3_primary_bucket_id}"
  description = "Name of the primary S3 bucket that serves as Source for xRegion Replication"
}

  output "s3_secondary_bucket_id" {
  value = "${module.cf_dist.s3_secondary_bucket_id}"
  description = "Name of the Secondary S3 bucket that serves as destination for xRegion Replication"
}
```