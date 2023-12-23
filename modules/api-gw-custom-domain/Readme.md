# API GW custom domain creation module for APIs in Capterra.
    This module is for creating API GW custom domain in Capterra.
    
#### What this module will do?
  ```
  # Create Amazon certificate (ACM).
  # Will wait for ACM certificate to wait for to get to issued Status
  # Create API GW Custom Domain with:-
      Security as TLS_1.2
      Automatically adds cert_domain_name to the custom domain alias.
  # Create DNS record in appropriate Hosted zone to point the API GW custom domain to EDGE distribution created in Amazon account.
  # Note: 
        * This module will map the API ID and its stage with the created Custom Domain.
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
* region_aws -- region of primary bucket (default: us-east-1)
* cert_hosted_zone_name -- Name of the Hosted Zone under which the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g "capstage.net." or "capterra.com." etc.
* hosted_zone_id -- Route 53 hosted zone_id for domain_name. This is automatically calculated via Datasource present in caller of module.
* apigw_custom_domain_name -- This is certificate domain that needs to be whitelisted. Also used for the Name tag of the ACM certificate.  Format e.g dd.capstage.net
* r53_dns_ttl -- Route 53 record time-to-live (TTL) for validation record (default: 60).
* apgdn_types -- apgdn_types is type. This resource currently only supports managing a single value. Valid values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions. Default is ["EDGE"]
* apigw_security_policy -- apigw_security_policy is type of TLS. The Transport Layer Security (TLS) version + cipher suite for this DomainName. The valid values are TLS_1_0 and TLS_1_2. Must be configured to perform drift detection. Default value is TLS_1.2
* api_id -- The ID of the REST API to be associated. Eg: rtd7ydou0m
* api_stage_name -- The stage name of the REST API to be associated. Eg: staging , prod



2) These variables are those needed in the caller of module. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* account_alias -- This is the name of account alias.
* aws_acm_certificate_arn -- The Amazon Resource Name (ARN) of the ACM Certificate created
* apigw_dn_id -- The ID of API GW Domain just created
* apigw_dn_arn -- The ARN of API GW domain just created


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


module "apigw_cd" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/api-gw-custom-domain"
  source                         = "../../../modules/api-gw-custom-domain"
  name                           = "dd"
  stage                          = var.stage
  vertical                       = "capterra"
  cert_hosted_zone_name          = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  region_aws                     = "us-east-1"
  apigw_custom_domain_name       = var.apigw_custom_domain_name
  api_id                         = var.api_id
  api_stage_name                 = var.api_stage_name

  providers = {
    #aws = "aws"
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.route53_account = "aws.route53_account"
  }

  #Specify tags here
    tag_application                    = "declared-data"
    tag_app_component                  = "capterra"
    tag_function                       = "custom-domain"
    tag_business_unit                  = "gdm"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra_devops"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "staging"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "declared-data"
    tag_environment                    = "staging"
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

  #Added below variables to support passing value from outside to module (Especially via Jenkins)

 variable "apigw_custom_domain_name" {
  description = "apigw_custom_domain_name to be passed to module. Eg: dd.capstage.net"
}

variable "stage" {
  description = "stage to be passed to module. Eg: dev, staging etc"
}

variable "api_id" {
    type = "string"
    description = "The ID of the REST API to be associated. Eg: rtd7ydou0m"
}

variable "api_stage_name" {
    type = "string"
    description = "The stage name of the REST API to be associated. Eg: staging , prod"
}
 
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. cf_dist is the reference used while calling module. Sample Below-
```  
output "apigw_dn_id" {
  value = "${module.apigw_cd.apigw_dn_id}"
  description = "The ID of Cloudfront distribution just created for Serverless App" 
}

output "aws_acm_certificate_arn" {
  value = "${module.apigw_cd.aws_acm_certificate_arn}"
  description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
}

output "apigw_dn_arn" {
  value = "${module.apigw_cd.apigw_dn_arn}"
  description = "The iam_arn of Cloudfront OAI just created for Serverless App"
}
```