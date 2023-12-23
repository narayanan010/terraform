# Module for WAF.
This module is for creating an AWS DLM Policies.
This module is meant to be used by all the accounts that need it. It could be easily adapted/extended with new policies.
    
#### What this module will do?
* Create the Capterra standard backup policies with no cross region replication (feature currently affected by a BUG)

## Usage:

When making use of this module:
  1. Define a variable for the role to be assumed and for the region in which you need to work:
    ```
    variable "modulecaller_source_region" {
    default     = "us-east-1"
    description = "Region to be passed to Provider info where calling module"
    }

    variable "modulecaller_assume_role_deployer_account" {
    default = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
    description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
    }

    variable "vertical" {
    default = "capterra"
    }

    ```
  2. Reference those variables in your provider.tf:
    ```

    terraform {
    backend "s3" {}
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.20.1"
        }
    }
    }

    provider "aws" {
    region  = var.modulecaller_source_region
    assume_role {
        role_arn = var.modulecaller_assume_role_deployer_account
    }
    default_tags {
        tags = module.tags_resource_module.tags
    }
    }

    ```
  3. Replace value of all the variables of the module per need


## Variables: 

The module is structured to give you the possibility to deploy the standard backup policies for prod, staging and dev (with no cross region replication) using the following variables:

### General variables:
| Variable | Type | Description | Constraint | Default |
| -------- | ---- | ----------- | ------- | ------- |
| vertical | string | The vertical the infrastructure belongs to: (e.g. Capterra) | "capterra", "getapp", "softwareadvice" | "capterra" |
| prod_backup_enabled | bool | Define if the backup plans are enabled for prod | | "false" |
| staging_backup_enabled | bool | Define if the backup plans are enabled for staging | | "false" |
| dev_backup_enabled | bool | Define if the backup plans are enabled for dev | | "false" |
| cross_region_key_arn | bool | (CROSS REGION FEATURE DISABLED) The key to be used to encrypt in cross region ami copies | | "" |
| dlm_lifecycle_role_arn | bool | The CUSTOM role to be used by the DLM service, if needed | | "" |


## Examples:
### Example of main.tf
```
module "aws_dlm_module" {
  source = "../../../../modules/ec2-data-lifecycle-manager"
  
  vertical                                  = var.vertical
  prod_backup_enabled                       = true
  staging_backup_enabled                    = false
  dev_backup_enabled                        = false
}

module "tags_resource_module" {
  source                  = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application             = "backup"
  app_component           = "dlm"
  function                = "automation"
  business_unit           = "gdm"
  app_contacts            = "capterra_devops"
  created_by              = "fabio.perrone@gartner.com"
  system_risk_class       = "3"
  region                  = var.modulecaller_source_region
  monitoring              = "false"
  terraform_managed       = "true"
  vertical                = var.vertical

  tags = {
    "repository"          = "https://github.com/capterra/terraform.git"
  } 
}
```
