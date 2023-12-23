variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "slack_channel_webhook" {
  description = "A webhook url to post to slack channel"
}

variable "runtime_lambda" {
  description = "Runtime to be used and its version"
  default     = "nodejs12.x"
}

variable "bucket_name" {
  description = "S3-Bucket-name-prefix"
  default = "tf-capterra-cloudtrail-logs"
}

variable "sns_topic_name" {
  description = "The name of the SNS Topic to send events to"
  default     = "tf-slacktosecurity-sns-topic"
}

variable "aws_account_id" {
  description = "AWS-Account-ID. The data caller identity always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider. https://github.com/terraform-providers/terraform-provider-aws/issues/386"
 }