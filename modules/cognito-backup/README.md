<!-- BEGIN_TF_DOCS -->
## Intro
The module creates a system for saving users from Cognito Users Pools to objects in S3.
The solution is composed by a step function, which use a first Lambda for selecting the targets of the backup (check for tag backup = true in Cognito user pool) and then the list of user pools ids is passed as input to a parallel processing. In each one of those, a lambda will do a backup and will save in S3 the object. To cover the use case of very large user pools, the lambda stops after 100000 users and forward as output the netx pagination token of the boto3 call, then a new lambda will start from the token received as input.
The step function is triggered by eventbridge.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.backup_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eventbridge_trigger_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.backup_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.eventbridge_trigger_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.backup_executor_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.backup_selector_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.backup_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup_executor_lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.backup_executor_lambda_cognito_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.backup_selector_lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.backup_selector_lambda_cognito_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.backup_executor_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.backup_selector_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.backup_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.delete_after_30days](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [null_resource.executor_code_build](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.selector_code_build](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.cognito_backup_executor_lambda_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.cognito_backup_selector_lambda_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudwatch_log_group.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_iam_policy_document.assume_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_executor_lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_selector_lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eventbridge_trigger_sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_cloudwatch_logs_policy"></a> [attach\_cloudwatch\_logs\_policy](#input\_attach\_cloudwatch\_logs\_policy) | Controls whether CloudWatch Logs policy should be added to IAM role for Lambda Function | `bool` | `true` | no |
| <a name="input_attach_policies_for_integrations"></a> [attach\_policies\_for\_integrations](#input\_attach\_policies\_for\_integrations) | Whether to attach AWS Service policies to IAM role | `bool` | `true` | no |
| <a name="input_aws_region_assume_role"></a> [aws\_region\_assume\_role](#input\_aws\_region\_assume\_role) | Name of AWS regions where IAM role can be assumed by the Step Function | `string` | `""` | no |
| <a name="input_backup_schedule_expression"></a> [backup\_schedule\_expression](#input\_backup\_schedule\_expression) | Schedule expression for triggering the backup sfn | `string` | `"cron(0 1 * * ? *)"` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Name of Cloudwatch Logs group name to use. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `null` | no |
| <a name="input_cloudwatch_log_group_tags"></a> [cloudwatch\_log\_group\_tags](#input\_cloudwatch\_log\_group\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create IAM role for the Step Function | `bool` | `true` | no |
| <a name="input_definition"></a> [definition](#input\_definition) | The Amazon States Language definition of the Step Function | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | `""` | no |
| <a name="input_logging_configuration"></a> [logging\_configuration](#input\_logging\_configuration) | Defines what execution history events are logged and where they are logged | `map(string)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `"us-east-1"` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The Amazon Resource Name (ARN) of the IAM role to use for this Step Function | `string` | `""` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of IAM role to use for Step Function | `string` | `null` | no |
| <a name="input_role_force_detach_policies"></a> [role\_force\_detach\_policies](#input\_role\_force\_detach\_policies) | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role to use for Step Function | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role to use for Step Function | `string` | `null` | no |
| <a name="input_role_permissions_boundary"></a> [role\_permissions\_boundary](#input\_role\_permissions\_boundary) | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Step Function | `string` | `null` | no |
| <a name="input_role_tags"></a> [role\_tags](#input\_role\_tags) | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| <a name="input_service_integrations"></a> [service\_integrations](#input\_service\_integrations) | Map of AWS service integrations to allow in IAM role policy | `any` | `{}` | no |
| <a name="input_sfn_state_machine_timeouts"></a> [sfn\_state\_machine\_timeouts](#input\_sfn\_state\_machine\_timeouts) | Create, update, and delete timeout configurations for the step function. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of tags to assign to the Step Function | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD \| EXPRESS | `string` | `"STANDARD"` | no |
| <a name="input_use_existing_cloudwatch_log_group"></a> [use\_existing\_cloudwatch\_log\_group](#input\_use\_existing\_cloudwatch\_log\_group) | Whether to use an existing CloudWatch log group or create new | `bool` | `false` | no |
| <a name="input_use_existing_role"></a> [use\_existing\_role](#input\_use\_existing\_role) | Whether to use an existing IAM role for this Step Function | `bool` | `false` | no |
| <a name="input_vertical"></a> [vertical](#input\_vertical) | Name of the vertical | `string` | `"capterra"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the S3 bucket to save backups. |
| <a name="output_step_function_arn"></a> [step\_function\_arn](#output\_step\_function\_arn) | The ARN of the Step function created. |
<!-- END_TF_DOCS -->