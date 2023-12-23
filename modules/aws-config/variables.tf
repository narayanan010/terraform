variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "runtime_lambda" {
  description = "Runtime to be used and its version"
  default     = "python3.9"
}

variable "bucket_name" {
	description = "S3-Bucket-name-prefix"
	default = "custom-config-bucket"
}

variable "is_config_managed_by_ccoe" {
  type = bool
  description = "If config is managed by ccoe, the recorder will not be created"
  default = false
}

variable "is_config_bucket_managed_by_ccoe" {
  type = bool
  description = "If config bucket is managed by ccoe, the bucket and its policy will be not created"
  default = false
}

variable "is_forwarding_to_slack_enabled" {
  type = bool
  description = "If true events will be sent to remote event bus and then forwarded to Slack."
  default = true
}

variable "destination_event_bus_arn" {
  type = string
  description = "The event bus to send config compliance events"
}