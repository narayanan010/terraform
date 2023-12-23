<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.scalyr_logs_ingester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.bucket_nwaf_logsotification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sqs_queue.logs_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.logs_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_for_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.get_waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.scalyr_logs_ingester_remote_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | This is the name of the account: main, search, crf. | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | This is region where tf template is to be deployed | `string` | `"us-east-1"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage this resource belongs to (dev/prod/staging/sandbox) | `string` | n/a | yes |
| <a name="input_vertical"></a> [vertical](#input\_vertical) | Vertical this resource belongs to (capterra/getapp/softwareadvice) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scalyr_iam_role_arn"></a> [scalyr\_iam\_role\_arn](#output\_scalyr\_iam\_role\_arn) | ARN of iam role used by Scalyr |
| <a name="output_scalyr_monitor"></a> [scalyr\_monitor](#output\_scalyr\_monitor) | Scalyr monitor to be added in https://app.scalyr.com/monitors |
| <a name="output_waf_logs_notification_sqs_arn"></a> [waf\_logs\_notification\_sqs\_arn](#output\_waf\_logs\_notification\_sqs\_arn) | ARN of sqs used for notify presence of WAF Logs |
| <a name="output_waf_logs_notification_sqs_url"></a> [waf\_logs\_notification\_sqs\_url](#output\_waf\_logs\_notification\_sqs\_url) | URL of sqs used for notify presence of WAF Logs |
| <a name="output_waf_logs_s3_bucket_name"></a> [waf\_logs\_s3\_bucket\_name](#output\_waf\_logs\_s3\_bucket\_name) | Name of s3 bucket used for WAF Logs |
<!-- END_TF_DOCS -->