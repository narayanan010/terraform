# Terraform Tagging module for Newly created Resources in Capterra.
This module is for adding or update tags over resources.

*** Beta NEW: include automatic labeling S3 resources

&nbsp;
## What this module will do?
  ```
  # Add Gartner specified standard tags to the resources. Gartner Tags included in module:
    `application, app_component, function, business_unit, app_environment, app_contacts, created_by, system_risk_class, region, network_environment, monitoring`
  # Add Capterra specified standard tags to the resources. Capterra Tags included in module:
    `terraform_managed, vertical, product, environment`
  # Note: 
        * This module will create tags for resources. Refer link: Refer Link: https://confluence.gartner.com/pages/viewpage.action?pageId=139892570
        * It also supports adding more tags while calling module using map tags {}.
        * This module will merge all tags from local.optional_xx (when xx (variable) is defined while module is called) and var.tags. Custom tags {} those need to be added to all resources can be passed via tags {} while calling module
        * This module also supports applying all tags specified while calling module + some additional tags only for the resource passed via map and merge. Refer "Sample Usage while creating Security Group" section below for reference.
```
&nbsp;

### Usage:

When making use of this module:
 1. If you want to add custom-tags along with the standard ones; Include `tags` object in each resource or module where you want to add it:
```
    tags = {
      Name        = "test_bucket"
    }
```

 2. If you want to add only tags which are part of module code, and no other custom tags to resources; Include only tags object `default_tags` in provider definition:
```
    default_tags {
      tags = module.tags_resource_module.tags
    }
```
&nbsp;


### Inputs from module:

The variables that are passed to module internally. These must be assigned from outside. Values of these vars can be assigned when calling module from outside. Gartner Specified variables are: 


|Module Parameter|Type|Required|Default Value|Valid Values|Description|
|-|-|-|-|-|-
|application|string|YES|`null`|`any`|Application name; a unifying name for the system involved. Must be globally unique across ALL of Gartner (there is only one 'gcom'), and must be uniform across all components of the app (all of these components are parts of the 'gcom' application). Must use only lowercase characters, numbers or hyphens. No uppercase, underscores, whitespaces or special characters. Eg: aem, sugar, cppdocs, gcom.
|app_component|string|YES|`null`|`any`|Breakdown of the functional parts ('components' or 'subservices') that make up an application. Grouping is based more on function than underlying technology. For example Alfresco components could be Share, Repository, Solr, and Transformation. GCOM components could be gproduct, gsearch, recengine, etc. If there are replicas of a given component ('blue/green', 'side-a/side-b') these should be tagged as independent app components. Ex: 'search_solr_a' and 'search_solr_b'. Underlying services that work together to make up a component should be tagged with the same app_component tag, for example, loadbalancers, ASGs, and DBs for gsearch would have the same app_component tag: gsearch
|function|string|YES|`null`|`any`|Used to identify function of server or resource (app layer)
|business_unit|string|YES|`null`|`any`|The IT business unit paying for this application out of their budget, in lowercase
|app_environment|string|YES|`null`|`any`|Could be the same as network environment, except in the case of multiple app environments within a single network environment
|app_contacts|string|YES|`null`|`any`|Application team DL with @gartner.com removed (local-part only)
|created_by|string|YES|`null`|`any`|Email address of person creating infrastructure (typically the person who writes the Terraform)
|system_risk_class|integer|YES|`null`|`[1/2/3]`|Please review our System Risk Classification page to determine whether your application is 1, 2 or 3. Here at: 'https://confluence.gartner.com/display/CLOUDCOE/System+Risk+Classification'
|region_aws|string|YES|`us-east-1`|`AWS values`|AWS region for `deployer account` where new services is going to be deployed
|network_environment|string|YES|`null`|`[sandbox/dev/qa/staging/prod]`|Network Env is a reference to the VPC you are building in
|monitoring|bool|NO|`true`|`[true/false]`|Set as true for monitoring. If a tag is set 'monitoring:false' monitoring will not be provided to this AWS object
|terraform_managed|bool|NO|`true`|`[true/false]`|Set as true for tf managed reesources
|vertical|string|YES|`null`|`[capterra/getapp/softwareadvice/gdm/sa]`|Name of vertical
|product|string|YES|`null`|`any`|Name of Product
|environment|string|YES|`null`|`[dev/prod/prod-dr/staging/sandbox]`|Name of environment

&nbsp;

### Outputs from module: 
Below outputs can be exported from module:

- tags &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - This is map of all tags applied via module
- label_s3 &nbsp; - Default labeling proposed for S3 bucket

&nbsp;

## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Include Below section to caller's main.tf

All tags will be present as `tags_all` over all final resource created that supports tagging

```
provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }

  ignore_tags {
    key_prefixes = ["tags","tags_all"]
    keys = ["CreatorAutoTag","CreatorId","last_update"]
  }
}

module "tags_resource_module" {
  source                         = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"

  application                    = "testapp"
  app_component                  = "sg"
  function                       = "testfunc"
  business_unit                  = "cap-bu"
  app_environment                = "sandbox"
  app_contacts                   = "capterra-devops"
  created_by                     = "sarvesh.gupta@gartner.com"
  system_risk_class              = "1"
  region                         = "us-east-1"
  network_environment            = "sandbox"             
  monitoring                     = "true"
  terraform_managed              = "true"
  vertical                       = "gdm"
  product                        = "capterra"
  environment                    = "sandbox"
}
```

If some optional tag are ommited, then the module won't add this tags.
If some tag are ommited and has default values, then the module will add this tags with default values.
If some mandatory tag are ommited or has incorrect value, then the module will notify about the error.

&nbsp;

### Joining custom tags ands default tags

Each resource can have custom tags showed as 'tags'. Default tags will be added as 'tags_all'

```
resource "aws_s3_bucket" "b" {
  bucket = "my-test-bucket"

  tags = {
    Name        = "test_bucket"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}
```

For the example above, `tags` (from bucket custom tags) and `tags_all` (from default_tags) will be joined in the final AWS resource created. Terraform will show tagging as two separated blocks

```
      + tags                        = {
          + "Name" = "test_bucket"
        }
      + tags_all                    = {
          + "Name"                = "test_bucket"
          + "app_component"       = "vpc"
          + "app_contacts"        = "capterra_devops"
          + "app_environment"     = "sandbox"
          + "business_unit"       = "gdm"
          + "created_by"          = "dan.oliva@gartner.com"
          + "environment"         = "dev"
          + "function"            = "test"
          + "git_path"            = "running_configs/vpc/capterra-sandbox/test"
          + "git_url"             = "https://github.com/capterra/terraform"
          + "iac_platform"        = "terraform: v1.2.1"
          + "last_update"         = "Wed 14 Sep 2022 11:33:23 CEST"
          + "monitoring"          = "true"
          + "network_environment" = "sandbox"
          + "product"             = "test"
          + "region"              = "us-east-1"
          + "runner_info"         = "hostname: C02GF85VMD6R ID: daoliva"
          + "system_risk_class"   = "1"
          + "terraform_managed"   = "true"
          + "vertical"            = "capterra"
        }
```


&nbsp;

### Ignoring Tags

If you don’t wish to add some default or custom tags, provider must include block `ignore_tags`. If `ignore_tags` block is added before create a new resource, listed tags won't be added. If `ignore_tags` block is added after create some resources, listed tags won't be updated or deleted from existing resources. 

```
provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  
  ignore_tags {
    key_prefixes = ["tags","tags_all"]
    keys = ["CreatorAutoTag","CreatorId","last_update"]
  }
}
```

&nbsp;

## Labeling Resources

Naming services standarization should be automatically based on tags provided. 

Each type of AWS resources has some naming rules and restrictions that must be checked before apply code

In next example when a new S3 bucket will be created, automatic labeling can be assigned

```
resource "aws_s3_bucket" "b" {
  bucket = module.tags_resource_module.label_s3

  tags = {
    Name        = "test_bucket"
  }
}
```

Based on Tagging Module, S3 bucket will be renamed based on `vertical`, `application` and `environment` followed by random string

```
module "tags_resource_module" {
  source = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"
  
  application         = "service-test"
  app_component       = "vpc"
  function            = "test"
  business_unit       = "gdm"
  app_environment     = "sandbox"
  app_contacts        = "capterra_devops"
  created_by          = "dan.oliva@gartner.com"
  system_risk_class   = "1"
  region              = "us-east-1"
  network_environment = "sandbox"
  monitoring          = true
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "test"
  environment         = "dev"
}


Outputs:

automatic_labeling_s3 = "capterra-service-test-dev-b4inid"

```

&nbsp;