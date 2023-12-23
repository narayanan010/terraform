<!-- BEGIN_TF_DOCS -->

# Module for DocumentDB.
This module is for creating a DocumentDB Cluster and associated resources.
    
## What this module will do?
* Create an AWS DocumentDB Cluster
* Create the Instances associated with the cluster
* Create a Security Group for the DocumentDB cluster
* Create Subnet Group for the cluster
* Create Parameter Group for the cluster

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
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags_resource_module"></a> [tags\_resource\_module](#module\_tags\_resource\_module) | git::https://github.com/capterra/terraform.git//modules/tagging-resource-module | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_docdb_cluster.docdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.cluster_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_docdb_cluster_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group) | resource |
| [aws_docdb_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group) | resource |
| [aws_ssm_parameter.DocDB_cluster_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether any minor engine upgrades will be applied automatically to the DB instance during the maintenance window or not | `bool` | `true` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | Name of the cluster which needs to be created. | `string` | n/a | yes |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Number of DB instances to create in the cluster | `number` | `3` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | DocumentDB port | `number` | `27017` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | A value that indicates whether the DB cluster has deletion protection enabled | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb` | `string` | `"docdb"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version number of the database engine to use | `string` | `"4.0.0"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs | `string` | `"db.r4.large"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. When specifying `kms_key_id`, `storage_encrypted` needs to be set to `true` | `string` | `""` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Name for the master user that will be used to authenticate to your cluster | `string` | n/a | yes |
| <a name="input_param_family"></a> [param\_family](#input\_param\_family) | List of VPC parameter | `string` | `"docdb4.0"` | no |
| <a name="input_parameter_key"></a> [parameter\_key](#input\_parameter\_key) | Name of the SSM\_parameter | `string` | `""` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | Daily time range during which the backups happen | `string` | `"07:00-09:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`. | `string` | `"Mon:22:00-Mon:23:00"` | no |
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | Number of days to retain backups for | `number` | `5` | no |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | ID of the VPC security groups in which cluster is deployed | `list(string)` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB cluster is deleted | `bool` | `true` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC subnet IDs to place DocumentDB instances in | `list(string)` | n/a | yes |
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
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Cluster Identifier |
| <a name="output_documentDB_arn"></a> [documentDB\_arn](#output\_documentDB\_arn) | This will provide the created cluster ARN |
| <a name="output_documentDB_id"></a> [documentDB\_id](#output\_documentDB\_id) | This will provide the created cluster ID |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint of the DocumentDB cluster |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | Username for the master DB user |
<!-- END_TF_DOCS -->