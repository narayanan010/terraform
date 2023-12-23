<!-- BEGIN_TF_DOCS -->

# Module for IAM Role for Service Account.

 This module is for creating a service role and associted resources.

 ## What this module will do?
 * Create Service role with Trust relationship

 ## What this module will NOT do?
 * Create a policy for the role
 * Create role policy attachment

 ## Usage:
 When making use of this module:
   1. Define a variable for the role to be assumed and for the region in which you need to work:
     ```
     variable "modulecaller_source_region" {
       default     = "us-east-1"
       description = "Region to be passed to Provider info where calling module"
     }

     variable "modulecaller_assume_role_deployer_account" {
       default     = "arn:aws:iam::350125959894:role/gdm-admin-access"
       description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
     }

     ```
   2. Reference those variables in your provider.tf:
     ```
     data "aws_caller_identity" "current" {}

     terraform {
       backend "s3" {}
       required_providers {
         aws = {
             source  = "hashicorp/aws"
             version = "~> 4.13.0"
             configuration_aliases = [ aws.primary ]
           }
       }
     }

     provider "aws" {
       alias   = "primary"
       region  = var.modulecaller_source_region
       assume_role {
         role_arn = var.modulecaller_assume_role_deployer_account
       }
     }
     ```
   3. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
   4. Replace value of all the variables of the module per need
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags_resource_module"></a> [tags\_resource\_module](#module\_tags\_resource\_module) | git::https://github.com/capterra/terraform.git//modules/tagging-resource-module | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster for which the policy needs to be created | `string` | `""` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment for which this role will be created. Example - 'prod', 'stage' | `string` | `""` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum CLI/API session duration in seconds between 3600 and 43200 | `number` | `3600` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the application for which this role will be created. Example - 'team-blog' | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the application for which this role will be created. Example - 'blog-ui' | `string` | `""` | no |
| <a name="input_provider_url"></a> [provider\_url](#input\_provider\_url) | URL of the OIDC Provider | `string` | n/a | yes |
| <a name="input_tag_app_component"></a> [tag\_app\_component](#input\_tag\_app\_component) | n/a | `string` | `""` | no |
| <a name="input_tag_app_contacts"></a> [tag\_app\_contacts](#input\_tag\_app\_contacts) | n/a | `string` | `"opsteam@capterra.com"` | no |
| <a name="input_tag_app_environment"></a> [tag\_app\_environment](#input\_tag\_app\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_application"></a> [tag\_application](#input\_tag\_application) | tags. These values can be overwritten when calling module. | `string` | `""` | no |
| <a name="input_tag_business_unit"></a> [tag\_business\_unit](#input\_tag\_business\_unit) | n/a | `string` | `""` | no |
| <a name="input_tag_created_by"></a> [tag\_created\_by](#input\_tag\_created\_by) | n/a | `string` | `"fabio.perrone@gartner.com"` | no |
| <a name="input_tag_environment"></a> [tag\_environment](#input\_tag\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_function"></a> [tag\_function](#input\_tag\_function) | n/a | `string` | `""` | no |
| <a name="input_tag_monitoring"></a> [tag\_monitoring](#input\_tag\_monitoring) | n/a | `string` | `""` | no |
| <a name="input_tag_network_environment"></a> [tag\_network\_environment](#input\_tag\_network\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_product"></a> [tag\_product](#input\_tag\_product) | n/a | `string` | `""` | no |
| <a name="input_tag_region"></a> [tag\_region](#input\_tag\_region) | n/a | `string` | `""` | no |
| <a name="input_tag_system_risk_class"></a> [tag\_system\_risk\_class](#input\_tag\_system\_risk\_class) | n/a | `string` | `"3"` | no |
| <a name="input_tag_terraform_managed"></a> [tag\_terraform\_managed](#input\_tag\_terraform\_managed) | n/a | `string` | `"true"` | no |
| <a name="input_tag_vertical"></a> [tag\_vertical](#input\_tag\_vertical) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of IAM role |
| <a name="output_iam_role_path"></a> [iam\_role\_path](#output\_iam\_role\_path) | Path of IAM role |
<!-- END_TF_DOCS -->
