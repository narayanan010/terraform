# Status: DEPRECATED
The module is kept for reference. It is not used as the Cloudtrail configuration is done at the organization level.

# AWS Cloudtrail module for Capterra AWS accounts.
    This module is for creation of AWS Cloudtrail and its dependencies, creation of AWS Cloudwatch rules to alert to slack aws_security_alerts channel. It creates all needed roles, Policies, SNS topic, lambda needed for alerting API calls and CloudTrail configurations.
    
#### What this module will do?
  ```
  # Create AWS CloudTrail and Cloudwatch rules in the region passed via variable.
  # Creates s3 Bucket for Cloudtrail in same account (but maps trail to default i.e capterra-cloudtrail-logs from aws-admin account), update policy. 
  # Creates lambda for sending alert to aws_security_alerts slack channel.
  # Creates SNS topic for subscription.
  # Creates Cloudwatch logs-group and stream.
  # Creates IAM roles and policies for CW, CT and SNS integration.
  # All total creates 19 resources.
  # Note: 
        * This module will require AWS account ID to be passed while calling module as data.aws_caller_identity.current.account_id returns root admin AWS account ID and not from assume_role calling ID when fetched automatically. This is bug in terraform provider. Refer:
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


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. These are: 

* region_aws -- This is region where tf template is to be deployed
* slack_channel_webhook -- A webhook url to post to slack channel (#aws-compliance)
* runtime_lambda -- Runtime to be used and its version (python3.6 by default)
* bucket_name -- S3-Bucket-name-prefix to be used in AWS-Config Configuration
* sns_topic_name -- The name of the SNS Topic to send events to.
* aws_account_id -- "AWS-Account-ID. The data caller identity always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider. https://github.com/terraform-providers/terraform-provider-aws/issues/386"

2) The variables those needed in the calling manifest. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* s3_bucket_name -- Name of s3 bucket used for AWS cloudtrail logs. Default is capterra-cloudtrail-logs bucket from aws-admin account..
* cw-rule_arn-ec2 -- ARN of CW Event Rule for ec2 API calls
* cw-rule_arn-iam -- ARN of CW Event Rule for IAM API calls
* cw-rule_arn-misc -- ARN of CW Event Rule for MISC API calls
* sns_topic_arn -- ARN of SNS Topic.
* lambda_arn -- ARN of lambda function to send alerts across slack security channel for various API calls those monitored via CW rules for API calls.

## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf. Modify backend info (key,etc) per requirement.
```
terraform {
  backend "s3" {
    bucket = "capterra-terraform-state"
    #Change below key per setup
    key    = "cloudwatch-trail/capterra-sandbox/us-east-1/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table" 
  }
}

provider "aws" {
  alias = "awscaller_account"
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

module "aws_trail_watch" {
  source                         = "/Users/sargupta/Capterra-github/terraform/modules/cloudwatch-trail"
  region_aws                     = "us-east-1"
  #Replace Account id with the id from assume_role account.
  aws_account_id                 = "944xxxxxx557"
  providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.capterra-aws-admin = "aws.capterra-aws-admin"
  }
}

```

#### Include Below section to caller's variables.tf, Replace values of all the variables with name beginning with modulecaller_xxxx per setup/requirement.
```
variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::944xxxxxx557:role/no-color-xxxxxxx-admin"
  description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
} 
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. cf_dist is the reference used while calling module. Sample Below-
```  
output "s3_bucket_name" {
  value = "${module.aws_trail_watch.s3_bucket_name}"
  description = "Name of s3 bucket used for AWS cloudtrail logs. Default is capterra-cloudtrail-logs bucket from aws-admin account."
}

output "cw-rule_arn-ec2" {
  value = "${module.aws_trail_watch.cw-rule_arn-ec2}"
  description = "Name of CW Event Rule for ec2 API calls"
}

output "cw-rule_arn-iam" {
  value = "${module.aws_trail_watch.cw-rule_arn-iam}"
  description = "Name of CW Event Rule for IAM API calls"
}

output "cw-rule_arn-misc" {
  value = "${module.aws_trail_watch.cw-rule_arn-misc}"
  description = "Name of CW Event Rule for MISC API calls"
}

output "sns_topic_arn" {
  value = "${module.aws_trail_watch.sns_topic_arn}"
  description = "ARN of SNS Topic"
}

output "lambda_arn" {
  value = "${module.aws_trail_watch.lambda_arn}"
  description = "ARN of Lambda"
}
```