variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "runtime_lambda" {
  type    = string
  description = "Runtime to be used and its version"
  default     = "python3.9"
}

variable "aws_notification_account" {
  type = string
  description = "Account used as central notification account"
  default = "176540105868"
}

variable "is_forwarding_to_slack_enabled" {
  type = bool
  default = true
}
