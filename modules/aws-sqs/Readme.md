<!-- BEGIN_TF_DOCS -->
## What this module will do?
 * Create a SQS queue
 * Create SQS access policy
 * Create CMK
 * Create FIFO (optional)
 * Create DLQ (optional)

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags_resource_module"></a> [tags\_resource\_module](#module\_tags\_resource\_module) | git::https://github.com/capterra/terraform.git//modules/tagging-resource-module | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.kms_key_aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sqs_queue.terraform_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.terraform_queue_deadletter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.logs_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sqs-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_duplication"></a> [content\_duplication](#input\_content\_duplication) | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). | `string` | `""` | no |
| <a name="input_dlq_required"></a> [dlq\_required](#input\_dlq\_required) | Deadletter queue is required or not. Boolean value | `bool` | `false` | no |
| <a name="input_duplication_scope"></a> [duplication\_scope](#input\_duplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue' | `string` | `"messageGroup"` | no |
| <a name="input_fifo_limit"></a> [fifo\_limit](#input\_fifo\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are 'perQueue' (default) and 'perMessageGroupId' | `string` | `"perQueue"` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Boolean designating a FIFO queue. If not set, it defaults to false making it standard | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key | `string` | `""` | no |
| <a name="input_kms_key_req"></a> [kms\_key\_req](#input\_kms\_key\_req) | Boolean to decide if KMS key need to be created or not | `bool` | `false` | no |
| <a name="input_maxReceiveCount"></a> [maxReceiveCount](#input\_maxReceiveCount) | Maximum receive message count in integer | `number` | `10` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `string` | `""` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message (from 60 (1 minute) to 1209600 (14 days) ) | `string` | `"345600"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the Queue to be created | `string` | `""` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). | `string` | `""` | no |
| <a name="input_redrivePermission"></a> [redrivePermission](#input\_redrivePermission) | Permissions to be given 'byQueue, denyAll, allowAll' | `string` | `"allowAll"` | no |
| <a name="input_role_name_sqs"></a> [role\_name\_sqs](#input\_role\_name\_sqs) | Role to be added in Principal policy | `any` | n/a | yes |
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
| <a name="input_visibility_timeout"></a> [visibility\_timeout](#input\_visibility\_timeout) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `string` | `"30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_arn"></a> [sqs\_arn](#output\_sqs\_arn) | The ARN of the SQS queue |
| <a name="output_sqs_id"></a> [sqs\_id](#output\_sqs\_id) | The URL for the created Amazon SQS queue. |
<!-- END_TF_DOCS -->