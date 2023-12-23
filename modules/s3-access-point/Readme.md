# AWS S3-Access-Points creation module for Capterra AWS accounts.
    This module is for creation of AWS S3 Access Points and its dependencies, like creation of s3 bucket, creation of KMS CMK for S3 encryption, Creation of Bucket Policies, CMK policies, and Access Point Policies.
    
#### What this module will do?
  ```
  # Create S3 Bucket in the region passed via variable.
  # Creates Access Point for s3 bucket in the same account. 
  # Creates s3 bucket policy and Maps it to S3 bucket created above.
  # Creates KMS CMK key.
  # Maps above created CMK key to SSE for s3 encryption.
  # Creates policy on KMS CMK created for user to allow access.
  # Creates S3 Access Point Policy and maps it to Access Point.

```

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account
  3. Optionally backend section can be moved to backend.tf in caller manifest. Or Keep it as is.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. Note: 
      You may choose to replace the policies in all 3 policy templates if you have policies that you need already handy/available for s3 bucket, s3 access-point, and KMS. Replaced policies will be applied when terraform apply is run, 

        OR
      
      You may also choose to use the existing policy templates, by making bare minimum changes. If you choose later please ensure that variables like $iamusername, $bucketsubdirname are passed when calling module so they are replaced in the policies while terraform apply is run.

  Details of all 3 .json.tpl files which contain policies for kms-cmk, s3-bucket, and s3-access-point. These are :

  * kms-policy.json.tpl : This policy will apply to kms-cmk. It contains variables like $account_id, $iamusername. Pass value of these variables while calling module.
  * s3-access-point-policy.json.tpl : This policy will apply to S3 access-point. It contains some variables like $account_id, $region_aws, $iamusername, $access_point_name and $bucketsubdirname. Pass value of these variables while calling module.
  * s3-policy.json.tpl : This policy will apply to s3 bucket. It contains some variables like $account_id, $bucket_name, $iamusername. Pass value of these variables while calling module.

    "$account_id" is automatically calculated and replaced in .tpl policies. Defintion of other variables used in the policy and module is provided below.

  7. After the module is run, below commands can be used to call GetObject or PutObject via Access Points. Sample commands(Replace curly braces with appropriate values):
```
  * aws s3api get-object --bucket arn:aws:s3:us-east-1:944xxxxxx557:accesspoint/{nameofAccessPoint} --key {bucketsubdirname}/put.html file.html
  * aws s3api put-object --bucket arn:aws:s3:us-east-1:944xxxxxx557:accesspoint/{nameofAccessPoint} --key {bucketsubdirname}/put.html --body file.html
```

### Variables: 

There are 2 types of variables used here:   


1) The variables that are passed to module internally. These can be overwritten when calling module from outside. These are: 

* region_aws -- This is region where tf template is to be deployed.
* bucket_name -- S3-Bucket-name for creation.
* vpc_id -- VPC ID that needs to be allowed via Network origin VPC via access-point
* access_point_name -- access_point_name that needs to be created for the bucket
* iamusername -- iam user that needs to be given access to the bucket and access point via bucket policy and access-point-policy.
* bucketsubdirname -- bucketsubdirname is the name of directory inside S3 bucket that needs to be given access via created Access Point for bucket

2) The variables those needed in the calling manifest. Names of such variables begin with "modulecaller_". 
   These needs to be declared in the variables.tf file besides main.tf when calling module. Value of these variables will be changed as needed. These variables are at the end of page.


### Outputs from module: 
Below outputs can be exported from module:

* s3_bucket_name -- Name of s3 bucket created.
* s3_access_point_ARN -- ARN of S3 Access Point Created.
* s3_access_point_domain-name -- domain-name of S3 Access Point Created.
* s3_access_point_ID -- ID of S3 Access Point Created.
* s3_access_point_network-origin -- Network-origin type of S3 Access Point Created. VPC.
* kms_arn -- ARN of KMS key.
* kms_key_id -- The globally unique identifier of the KMS key.

## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf. Modify backend info (key,etc) per requirement.
```
terraform {
  backend "s3" {
    bucket = "capterra-terraform-state"
    key    = "s3-access-point/capterra-sandbox/us-east-1/test-1/terraform.tfstate"
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

module "s3-access-point" {
  source                         = "/Users/sargupta/Capterra-github/terraform/modules/s3-access-point"
  region_aws                     = "us-east-1"

  #Change below inputs 'bucket_name', 'vpc_id', 'access_point_name', 'iamusername', and 'bucketsubdirname' as per requirements.
  bucket_name                    = "test-1-bucket-ap"
  vpc_id                         = "vpc-6bxxxx0d"
  access_point_name              = "test-1-ap"
  #Uncomment below 2 variables if you choose to use sample templates for policies
  #iamusername                    = "test-user"
  #bucketsubdirname               = "test"

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
  description = "Region where module runs, passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::944xxxxxx557:role/no-color-staging-admin"
  description = "Assume Role from the account that runs AWS S3-accesspoint module and other dependencies to be created"
}
```


### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. s3-access-point is the reference used while calling module. Sample Below-
```  
output "s3_bucket_name" {
  value = "${module.s3-access-point.s3_bucket_name}"
  description = "Name of s3 bucket used for AWS cloudtrail logs. Default is capterra-cloudtrail-logs bucket from aws-admin account."
}

output "s3_access_point_ARN" {
  value = "${module.s3-access-point.s3_access_point_ARN}"
  description = "ARN of S3 Access Point Created."
}

output "s3_access_point_domain-name" {
  value = "${module.s3-access-point.s3_access_point_domain-name}"
  description = "domain-name of S3 Access Point Created."
}

output "s3_access_point_ID" {
  value = "${module.s3-access-point.s3_access_point_ID}"
  description = "ID of S3 Access Point Created."
}

output "s3_access_point_network-origin" {
  value = "${module.s3-access-point.s3_access_point_network-origin}"
  description = "Network-origin type of S3 Access Point Created."
}

output "kms_arn" {
  value = "${module.s3-access-point.kms_arn}"
  description = "ARN of KMS key"
}

output "kms_key_id" {
  value = "${module.s3-access-point.kms_key_id}"
  description = "The globally unique identifier the of KMS key"
}
```