# Terraform module to set Cloudwatch-Log-Groups-Expiration for Capterra.

Terraform Module will set retention_days to CW-Log-Groups across Capterra AWS accounts.

&nbsp;

### What this module will do?
* Deploy lambda function that will set CW log group expiration in AWS Accounts.
* Create IAM roles with required permissions.
* Create CW logGroups and logstream for current lambda that is deployed.
* Create Daily CW-Cron schedule to trigger lambda that is deployed.
* retention_days will be set as Dev-Account=1 day, Staging-Account=1 day, Production-Account=30 days

&nbsp;

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account
  3. Backend can be configured using terragrunt.hcl as done in Capterra.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly

&nbsp;

### Inputs from module:

The variables that are passed to module internally. These can be overwritten when calling module from outside. These are:

|Module Parameter|Type|Required|Default Value|Valid Values|Description|
|-|-|-|-|-|-
|region_aws|string|NO|`us-east-1`|`AWS values`|AWS region for `main account` where new services is going to be deployed
|retention_days|string|YES|`null`|`[1/3/5/7/14/30/60/90/120/150/180/365/400/545/731/1827/2192/2557/2922/3288/3653]`|Number of days to set for CW log groups in AWS account
|lambda_timeout|integer|YES|`30`|`[3-600]`|Timeout for lambda in seconds
|eventbridge_rule_enabled|bool|NO|`true`|`[true/false]`|Enable or disable EventBridge execution
|cw_loggroups_excluded|list|NO|`[]`|`["any"]`|Enable or disable EventBridge execution

&nbsp;


### Outputs from module: 
Below outputs can be exported from module:

- iam_role_arn &nbsp;&nbsp; - The Amazon Resource Name (ARN) of the IAM Role created for lambda-cloudwatch association
- lambda_arn &nbsp;&nbsp;&nbsp;&nbsp; -  ARN of Lambda function created.
- lambda_retencion_policy_exclusions &nbsp;&nbsp; - List of log groups excluded from retention policy

&nbsp;

## Sections to be added to module caller's main.tf

#### Include Below section to caller's main.tf
```
module "cloudwatch-log-expiration_module" {
  source = "git::https://github.com/capterra/terraform.git//modules/cloudwatch-log-expiration-module"

  region_aws               = var.modulecaller_source_region
  retention_days           = "14"
  lambda_timeout           = var.lambda_timeout
  eventbridge_rule_enabled = true
}
```
&nbsp;
