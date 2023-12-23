# Cloudfront module for Serverless-Apps for Capterra.
    This module is for creating CF distro for Serverless Apps in Capterra.
    
#### What this module will do?
  ```
  # Create S3 bucket with static web hosting enabled.
  # Create Amazon certificate (ACM).
  # Will wait for ACM certificate to wait for to get to issued Status
  # Create Cloudfront Distribution with:-
      Error page redirecting 404 and 403 errors to index.html
      Origin access identity created
      Updating the bucket policies of primary bucket to restrict access to OAI only.
      Automatically adds cert_domain_name to cloudfront alias.
      Creates 2 separate origins, One pointing to s3 bucket created above. And another pointing to API Gateway Endpoint deduced from Cloudformation Stack. The name of Cloudformation stack should passed via `cloudformationstackname` variable. And the variable that stores endpoint must be passed via `cloudformation_stack_output_endpoint_variable`.
      Create Cloudfront log bucket and enable logging for the created Cloudfront Distribution.
  # Create DNS record in appropriate Hosted zone to point to the cloudfront distribution created above. Pass Hosted zone using var: `cert_hosted_zone_name`
  # Note: 
        * This module will accept single domain name for ACM cert. subject_alternative_names aren't supported due to current issue witn provider mentioned here: https://github.com/terraform-providers/terraform-provider-aws/issues/8531 . Future versions of module will support this functionality if needed.
        * In 'default_cache_behavior' section in module, Uncomment the <headers> section to add the list of whitelisted headers to default cache behavior under <Cache Based on Selected Request Headers: Whitelist> value in Cloudfront. And pass list of headers via variable "cf_forward_header_values" while calling module. Or else <Cache Based on Selected Request Headers: None> is set with no whitelisted headers.
        * For API-Gateway Origin in Cloudfront, Module expects the Cloudformation Stack output Variable's value in format as: https://{url}/{api-stage} ; in order to deduce domain_name and origin_path automatically for Cloudfront. Eg: https://iqaedf32r4.execute-api.us-east-1.amazonaws.com/sandbox. Default Cloudformation o/p variable where the value is picked from is "ServiceEndpoint". When calling module Custom Variables can also be passed if some other variable in Cloudformation holds the API Gateway endpoint. 
```

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account, 
        var.modulecaller_assume_role_dns_account
  3. Optionally backend section can be moved to separate backend.tf in caller terraform file. Or Keep it as is in below.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly
  7. data "aws_route53_zone" "zone" {} section is included below, as this is needed to automatically deduce the zone_id required for CNAME record insertion in the hosted_zone during ACM validation via DNS method, and during the final CNAME creation that points to Created Cloudfront Domain. Keep it as is.


### Variables: 

There are 2 types of variables used here:   


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. Some of these are: 

* namespace -- This will be used in naming of resources created. Default: gdm
* name -- name of application. Required to be passed from caller of module.
* stage -- name of stage (dev/stg/prod/sandbox). Required to be passed from caller of module.
* vertical -- name of vertical (capterra/getapp/SA). Default: capterra
* cloudformationstackname -- Cloudformation stack name that will hold the API Gateway Url Endpoint. Required to be passed from caller of module.
* cloudformation_stack_output_endpoint_variable -- Variable that hold the API Gateway endpoint in cloudformation stack. Default: "ServiceEndpoint". Required to be passed from caller of module.
* s3_path_pattern -- The Path Pattern for the Ordered Cache Behavior. Eg: search/assets/test/* .No default value, Required to be passed from outside.
* region_aws -- region of primary bucket (default: us-east-1)
* cert_hosted_zone_name -- Name of the Hosted Zone under which the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g "capstage.net." or "capterra.com." etc.
* hosted_zone_id -- Route 53 hosted zone_id for domain_name. This is automatically calculated via Datasource present in caller of module.
* cert_domain_name -- This is certificate domain that needs to be whitelisted. Also used for the Name tag of the ACM certificate. This will also be added to CNAME alias in cloudfront automatically.  Format e.g serverlessapp1-test.capstage.net
* r53_dns_ttl -- Route 53 record time-to-live (TTL) for validation record (default: 60).
* cf_forward_query_string -- Forward query string to the origin that is associated with s3 cache behavior. 
* cf_minimum_protocol_version -- The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018
* cf_default_root_object -- Default root object that CF Distro will point to. Default: index.html
* cf_viewer_protocol_policy -- Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https.
* cf_price_class -- The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100
* prefix_api_gateway_endpoint -- prefix_api_gateway_endpoint is Prefix of API Gateway URL. This value is trimmed to get the endpoint for CF origin. One of: https:// or http://
* aws_cf_log_account_canonical_id -- This is `awslogsdelivery` access for CF logging to S3 bucket.
* cf_forward_query_string_api -- Forward query string to the origin that is associated with api cache behavior. Valid values true/false.
* custom_default_ttl -- Default TTL for default_cache_behavior (s3)
* custom_max_ttl -- Max TTL for default_cache_behavior
* custom_min_ttl -- Min TTL for default_cache_behavior
* ordered_cache_behavior_default_ttl -- Default TTL for ordered_cache_behavior (api)
* ordered_cache_behavior_max_ttl -- Max TTL for ordered_cache_behavior
* ordered_cache_behavior_min_ttl -- Min TTL for ordered_cache_behavior
* cf_response_page_path -- cf_response_page_path CF distro's error pages section will point to. Default: /index.html
* cf_error_caching_min_ttl -- cf_error_caching_min_ttl CF distro's error pages section will point to. Default: 0
* cf_response_code -- cf_response_code CF distro's error pages section will point to. Default: 200
* cf_aliases -- List of extra aliases that needs to be added to CF distro. Before adding ensure that ACM cert whitelists the alias to be added. By Default, Module adds cert_domain_name automatically to CF alias. This doesn't need to be passed to add cert_domain_name to CF Alias.
* custom_origin_config_api-http_port -- This is for Custom Origin Config. The HTTP port the custom origin listens on. HTTP Port for Custom API Gateway Origin for Cloudfront. Default: "80"
* custom_origin_config_api-https_port -- This is for Custom Origin Config. The HTTPS port the custom origin listens on. HTTPS Port for Custom API Gateway Origin for Cloudfront. Default: "443"
* custom_origin_config_api-origin_protocol_policy -- This is for Custom Origin Config. The origin protocol policy to apply to your origin. For Custom API Gateway Origin for Cloudfront. One of http-only, https-only, or match-viewer. Default: "https-only"
* custom_origin_config_api-origin_ssl_protocols -- This is for Custom Origin Config. The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. For Custom API Gateway Origin for Cloudfront. A list of one or more of [SSLv3, TLSv1, TLSv1.1, TLSv1.2]. Default: ["TLSv1"]
* custom_origin_config_api-origin_keepalive_timeout -- For API Gateway Custom Origin. The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. Default: "5"
* custom_origin_config_api-origin_read_timeout -- For API Gateway Custom Origin. The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. Default: "30"
* ordered_cache_behavior_viewer_protocol_policy -- Viewer Protocol policy for ordered cache behavior. Valid values are One of: allow-all, https-only, or redirect-to-https. Default: "redirect-to-https"
* cf_forward_header_values -- A list of whitelisted header values to send to origin server for default_cache_behavior. Default: [""] .Sample eg: ["CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"] etc. Refer top of readme for more details under Note section.



2) These variables are those needed in the caller of module. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* s3_primary_bucket_id -- Name of the primary S3 bucket that serves as Origin for Cloudfront
* s3_primary_bucket_arn -- The Amazon Resource Name (ARN) of the Primary S3 bucket that serves as Source for xRegion Replication
* aws_acm_certificate_arn -- The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App.
* cloudfront_distro_id -- The ID of Cloudfront distribution just created for Serverless App
* cloudfront_distro_arn -- The ARN of Cloudfront distribution just created for Serverless App
* cloudfront_distro_domain_name -- The domain_name of Cloudfront distribution just created for Serverless App
* cloudfront_OAI_id -- The ID of Cloudfront OAI just created for Serverless App
* cloudfront_OAI_iam_arn -- The iam_arn of Cloudfront OAI just created for Serverless App
* r53_dns_domain_name -- The name of DNS record just created for Serverless App
* s3_cf_log_bucket_arn -- Name of the log s3 bucket that serves as log storage for Cloudfront Distro
* s3_cf_log_bucket_id -- ID of the log s3 bucket that serves as log storage for Cloudfront Distro


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf
```
terraform {
  backend "s3" {
    bucket = "capterra-terraform-state"
    key    = "cloudfront-serverlessapp/serverlessapp1/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    #dynamodb_table = "capterra-terraform-lock-table" 
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


module "cf_dist_serverless" {
  source                         = "/Users/sargupta/Capterra-github/terraform/modules/Cloudfront_Serverless_Apps"
  name                           = "serverlessapp1-test"
  stage                          = "sandbox"
  vertical                       = "capterra"
  cloudformationstackname        = "StackSet-SpotInstRoleDeployment-e6685df4-d2f7-46f3-b6aa-9c3c3d8636d9"
  cloudformation_stack_output_endpoint_variable = "SpotinstRoleArn"
  cert_domain_name               = "serverlessapp1-test.capstage.net"
  cert_hosted_zone_name          = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  region_aws                     = "us-east-1"
  s3_path_pattern                = "search/assets/test/*"
  #cf_aliases                    = ["serverlessapp99-test-alias.capstage.net"]
  #cf_forward_query_string_api   = "true"
  #To use below 'cf_forward_header_values' in order to whitelist headers, uncomment <'headers' section under 'default_cache_behavior in Module'>
  #cf_forward_header_values       = ["CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"]
  providers = {
    #aws = "aws"
    aws.primary_cf_account = "aws.primary_cf_account"
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
  value = "${module.cf_dist_serverless.cloudfront_distro_id}"
  description = "The ID of Cloudfront distribution just created for Serverless App" 
  }

output "aws_acm_certificate_arn" {
  value = "${module.cf_dist_serverless.aws_acm_certificate_arn}"
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
  }

output "cloudfront_OAI_iam_arn" {
  value = "${module.cf_dist_serverless.cloudfront_OAI_iam_arn}"
  description = "The iam_arn of Cloudfront OAI just created for Serverless App"
  }

output "r53_dns_domain_name" {
  value = "${module.cf_dist_serverless.r53_dns_domain_name}"
  description = "The name of DNS record just created for Serverless App"
  }

output "s3_primary_bucket_id" {
  value = "${module.cf_dist_serverless.s3_primary_bucket_id}"
  description = "Name of the primary S3 bucket that serves as Origin for Cloudfront distribution"
  }

output "s3_cf_log_bucket_id" {
  value = "${module.cf_dist_serverless.s3_cf_log_bucket_id}"
  description = "Name of the Log S3 bucket that serves as Log Destination for Cloudfront distribution"
  }
```