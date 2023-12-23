# Terraform module for ECS Cluster - Fargate in Capterra.
    Terraform Module will bring up ECS cluster - Fargate in Capterra AWS accounts.
    
#### What this module will do?
```
  # This will create ECS Fargate cluster based upon parameters provided
  # This module will:
      * Create ECS cluster based upon the parametes provided.
      * It has an option to enable/disable Container Insights
      * Module tag is being used for tagging each resource per Capterra/Gartner standard tags.
  # Note:
      * 'create_ecs' var will control the creation of ECS cluster. Valid values are false/true
      * Module Caller's Provider.tf can have below provider configuration as specified in main.tf under section `Include Below section to caller's main.tf`
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

The variables that are passed to module internally. These can be overwritten when calling module from outside. These are: 

|Module Parameter|Type|Required|Default Value|Valid Values|Description|
|-|-|-|-|-|-
|region|string|YES|`us-east-1`|`AWS values`|This is region where module is to be deployed
|create_ecs|bool|YES|`true`|`true/false`|Controls if ECS should be created
|app|string|YES|`null`|`any`|Application Name, also the name to be used in prefix of the name of ECS cluster
|stage|string|YES|`null`|`any`|ENV name. eg: dev / staging / prod
|capacity_providers|list|NO|`[]`|`["FARGATE","FARGATE_SPOT"]`|List of short names of one or more capacity providers to associate with the cluster
|default_capacity_provider_strategy|object|NO|`{}`|`AWS values`|The capacity provider strategy to use by default for the cluster. Can be one or more
|container_insights|bool|NO|`false`|`true/false`|Controls if ECS Cluster has container insights enabled


### Outputs from module: 
Below outputs can be exported from module:

- `ecs_cluster_id` &nbsp;&nbsp;&nbsp;&nbsp; - ID of the ECS Cluster
- `ecs_cluster_arn` &nbsp;&nbsp; - ARN of the ECS Cluster
- `ecs_cluster_name`&nbsp;  - The name of the ECS cluster


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Example usage
```
data "aws_caller_identity" "current" {}


terraform {
     backend "s3" {}
 }


provider "aws" {
  version = "~> v2.55.0"
    region = var.role_region
    assume_role {
      role_arn = var.role_arn
    }
 }


module "ecs" {
  source = "git@github.com:capterra/terraform.git//modules/ECS/Fargate-Cluster"


  app                 = "myecs"
  stage               = "testenv"
  container_insights  = true
  capacity_providers  = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT"
    }
  ]
```

### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. "aws_redis_module" is the reference used while calling module. Sample Below-
```  
output "ecs_cluster_arn" {
  value = "${module.ecs.ecs_cluster_arn}"
  description = "ARN of ECS cluster"
}

output "ecs_cluster_id" {
  value = "${module.ecs.ecs_cluster_id}"
  description = "The ID of ECS cluster."
}

output "ecs_cluster_name" {
  value = "${module.ecs.ecs_cluster_name}"
  description = "Name of ECS cluster"
}
```