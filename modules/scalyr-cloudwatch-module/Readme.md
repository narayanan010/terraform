# Terraform module for scalyr-cloudwatch-module in Capterra.
    Terraform Module will deploy Cloudformation Template to Capterra AWS accounts. This cf-template will create Lambda function to stream logs to Scalyr.
    
#### What this module will do?
```
  # Deploy Cloudformation Template.
  # This CF template will:
      * Create IAM roles with required permissions.
      * Create Streamer Lambda Function to stream Cloudwatch logs to Scalyr
      * Create Subscriber Lambda Function for auto-subscription based upon regular expression in Future. We aren't using this in Capterra as of now. But its in there for future usage.
      * More details about cf-template: https://github.com/scalyr/scalyr-aws-serverless/tree/master/cloudwatch_logs
  # Terraform Module will:
      * Create KMS key, add alias to it.
      * Use KMS for encrypting Scalyr plain API key that was feeded as input to module 
      * The resulting Encrypted key will be used in Streamer lambda Function to push logs to Scalyr.
  # Add trigger to deployed Lambda Streamer Function as required. This trigger can be CW-Log-Group, API-Gateway etc.
  # TO-DO Manually: Configure the KMS key created above to Streamer lambda ENV-Variables for encryption/decryption. This needs to be done at `Encryption Configuration` section under `Environment-Variables. (Required, Must-Do)
  # Streamer Lambda function deployed by CF-Template by default only has option to set `host` as `cloudwatch-AccountID`. To use Custom host see details below.
```

#### Good to have (This is optional, Follow in-order to use Custom host in scalyr)
```
  # By default the alerts from account will show up under host `cloudwatch-AccountID` in scalyr. If you want alerts to be sent to custom host, Follow below steps:
      * Make changes to python Streamer lambda code to look for SERVER_HOST variable and pick value. To do this; At line 510, Replace:

            'host': options.get(
            'serverHost', f"cloudwatch-{message['owner']}"), 

              with

            'host': options.get(
            'serverHost', os.environ.get('SERVER_HOST')),

      * To use custom host, now lambda needs to pick value from SERVER_HOST variable added above in lambda code. So SERVER_HOST variable needs to be made available now. Goto Streamer lambda function and add Env-Variable. Eg: SERVER_HOST = capterra-sandbox 
```

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


### Variables: 

There are 2 types of variables used here:   


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. These are: 

* region_aws -- This is region where tf template is to be deployed. Default = us-east-1
* BaseUrl -- Base URL of the Scalyr API. Default = https://www.scalyr.com
* AutoSubscribeLogGroups -- Automatically subscribe the logGroups defined in LogGroupOptions to the CloudWatch Streamer Lambda function, Valid value: true/false. Default = false
* Debug -- Enable debug logging of each request, Valid value: true/false. Default = false
* WriteLogsKey -- Use this or WriteLogsKeyEncrypted. The Scalyr API key that allows write access to Scalyr logs. Default = ""
* WriteLogsKeyEncrypted -- Use this or WriteLogsKey. The encrypted Scalyr API key that allows write access to Scalyr logs. To get the encrypted key use AWS KMS. This variable will be set automatically based upon the Encrypted conversion of 'scalyrplainapikeytoencrypt' variable by KMS.
* LogGroupOptions -- Valid JSON string to customise log delivery. Default = "{}"
* template_url -- URL of the scalyr template. Currently picked from https://github.com/scalyr/scalyr-aws-serverless/tree/master/cloudwatch_logs#deployment . Default = https://scalyr-aws-serverless.s3.amazonaws.com/cloudwatch_logs/cloudwatch-logs-1.0.8.yml
* scalyrplainapikeytoencrypt -- scalyrplainapikeytoencrypt to be passed to KMS to get ciphertext.


2) The variables those needed in the calling manifest. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* cf_stack_id -- The ID of cloudformation stack created
* cf_outputs -- A List of output structures.
* ciphertext_blob -- Base64 encoded ciphertext from KMS post encryption.
* kms_arn -- The Amazon Resource Name (ARN) of the KMS key.
* kms_key_id -- The globally unique identifier for the key.


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf
```
 terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}
 
 provider "aws" {
   alias =  "awscaller_account"
     region = "${var.modulecaller_source_region}"
     assume_role {
       #Below Role is Callee account Role. This can be replaced in variables with any assume Role info.
       role_arn     = var.modulecaller_assume_role_primary_account
   }
 }

 #Added this to fix "argument region not set error" while running plan. Bug in Provider.
 provider "aws" {
   region = var.modulecaller_source_region
 }

module "scalyr_cloudwatch_module" {
  source                  = "../../../modules/scalyr-cloudwatch-module"
  region_aws              = var.modulecaller_source_region
  BaseUrl                 = var.BaseUrl
  AutoSubscribeLogGroups  = var.AutoSubscribeLogGroups
  Debug                   = var.Debug
  WriteLogsKey            = var.WriteLogsKey
  WriteLogsKeyEncrypted   = var.WriteLogsKeyEncrypted
  LogGroupOptions         = var.LogGroupOptions
  template_url            = var.template_url
  
  #capabilities = ["CAPABILITY_IAM","CAPABILITY_NAMED_IAM","CAPABILITY_AUTO_EXPAND"]
  scalyrplainapikeytoencrypt = var.scalyrplainapikeytoencrypt

  providers = {
    aws.awscaller_account = "aws.awscaller_account"
    #aws.capterra-aws-admin = "aws.capterra-aws-admin"
  }
}
```

#### Include Below section to caller's variables.tf, Replace values of all the variables with name beginning with modulecaller_xxxx
```
#Basic Variables
variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::944xxxxxx557:role/no-color-staging-admin"
  description = "Assume Role from the account in which resources are to be deployed to"
}



#Below are variables from within module.
variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "BaseUrl" {
  description = "Base URL of the Scalyr API"
  default = "https://www.scalyr.com"
}

variable "AutoSubscribeLogGroups" {
  description = "Automatically subscribe the logGroups defined in LogGroupOptions to the CloudWatch Streamer Lambda function, Valid value: true/false"
  default = "false"
}

variable "Debug" {
  description = "Enable debug logging of each request, Valid value: true/false"
  default = "false"
}

variable "WriteLogsKey" {
  description = "Use this or WriteLogsKeyEncrypted. The Scalyr API key that allows write access to Scalyr logs"
  default = ""
}

variable "WriteLogsKeyEncrypted" {
  description = "Use this or WriteLogsKey. The encrypted Scalyr API key that allows write access to Scalyr logs. To get the encrypted key use AWS KMS"
  default = ""
}

variable "LogGroupOptions" {
  description = "Valid JSON string to customise log delivery"
  default = "{}"
}

variable "template_url" {
  description = "URL of the scalyr template. Currently picked from https://github.com/scalyr/scalyr-aws-serverless/tree/master/cloudwatch_logs#deployment"
  default = "https://scalyr-aws-serverless.s3.amazonaws.com/cloudwatch_logs/cloudwatch-logs-1.0.8.yml"
}


#KMS variables
#variable "iamusername" {
#  description = "iamusername to be passed to KMS key policy to allow usage"
#  default = "scalyr_user"
#}

variable "scalyrplainapikeytoencrypt" {
  description = "SCALYR API Key to be passed to KMS to get ciphertext that will be passed in encrypted form to cf-template"
} 
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. "scalyr_cloudwatch_module" is the reference used while calling module. Sample Below-
```  
output "cf_stack_id" {
    value = "${module.scalyr_cloudwatch_module.cf_stack_id}"
    description = "The ID of cloudformation stack created"
}

output "cf_outputs" {
    value = "${module.scalyr_cloudwatch_module.cf_outputs}"
    description = "A List of output structures."
}

output "ciphertext_blob" {
    value = "${module.scalyr_cloudwatch_module.ciphertext_blob}"
    description = "Base64 encoded ciphertext from KMS post encryption."
}

output "kms_arn" {
    value = "${module.scalyr_cloudwatch_module.kms_arn}"
    description = "The Amazon Resource Name (ARN) of the KMS key."
}

output "kms_key_id" {
    value = "${module.scalyr_cloudwatch_module.kms_key_id}"
    description = "The globally unique identifier for the key."
}
```