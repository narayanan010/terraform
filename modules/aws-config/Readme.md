# AWS Config module for Capterra  AWS accounts.
    This module is for AWS config and its dependency creation and configuration.
    
#### What this module will do?
  ```
  # Create AWS config rules in the region passed via variable. Configure Recorder, Create s3 Bucket for config, update policy, create 4 lambdas for s3 encryption check, s3 policy check, ebs encryption check and send alert to compliance slack channel. 
  # Note: 
        * This module will require AWS account ID to be passed while calling module as data.caller_identity returns AWS account ID and not assume_role calling ID when fetched automatically. This is bug in terraform provider. Refer:
        https://github.com/terraform-providers/terraform-provider-aws/issues/386
```

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account
  3. Optionally backend section can be moved to backend.tf in caller manifest. Or Keep it as is.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly

### Variables: 

There are 2 types of variables used here:   


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. Some of these are: 

* region_aws -- This is region where tf template is to be deployed
* slack_channel_webhook -- A webhook url to post to slack channel (#aws-compliance)
* runtime_lambda -- Runtime to be used and its version (python3.6 by default)
* bucket_name -- S3-Bucket-name-prefix to be used in AWS-Config Configuration
* aws_account_id -- "AWS-Account-ID. The data caller identity always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider. https://github.com/terraform-providers/terraform-provider-aws/issues/386"

2) The variables those needed in the calling manifest. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* config_rule_id -- The ID of AWS Config Rule.
* config_recorder_id -- Name of AWS Config recorder
* s3_bucket_name -- Name of s3 bucket used for AWS Config


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf. Modify backend info (key,etc) per requirement.
```
terraform {
  backend "s3" {
    bucket = "capterra-terraform-state"
    #Replace key below per setup
    key    = "aws-config/capterra-sandbox/us-east-1/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table" 
  }
}

provider "aws" {
  alias = "awsconfig_account"
      region = var.modulecaller_source_region
      assume_role {
        role_arn     = var.modulecaller_assume_role_primary_account
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

module "aws-config" {
  source                         = "/Users/sargupta/Capterra-github/terraform/modules/aws-config"
  region_aws                     = "us-east-1"
  #Replace account_id below
  aws_account_id                 = "350xxxxx9894"
  providers = {
    #aws = "aws"
    aws.awsconfig_account = "aws.awsconfig_account"
    aws.capterra-aws-admin = "aws.capterra-aws-admin"
  }
}

```

#### Include Below section to caller's variables.tf, Replace values of all the variables with name beginning with modulecaller_xxxx
```
variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::350xxxxx9894:role/gdm-xxxxx-access"
  description = "Assume Role from the account that runs AWS Config and other dependencies to be created in"
} 
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. cf_dist is the reference used while calling module. Sample Below-
```  
output "config_rule_id" {
  value = "${module.aws-config.config_rule_id}"
  description = "The ID of AWS Config Rule" 
}

output "config_recorder_id" {
  value = "${module.aws-config.config_recorder_id}"
  description = "Name of AWS Config recorder"
}

output "s3_bucket_name" {
  value = "${module.aws-config.s3_bucket_name}"
  description = "Name of s3 bucket used for AWS Config"
}
```