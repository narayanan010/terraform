variable "modulecaller_source_region" {
  type = string
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

 variable "modulecaller_assume_role_deployer_account" {
   default     = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
   description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
 }

variable "runtime_lambda" {
  type = string
  description = "Runtime to be used and its version"
}

variable "cx_oracle_layer_name" {
  type = string
  description = "The name of cx_oracle layer to be used"
}

variable "memory_size" {
  type = string
  description = "The amount of memory for the lambda"
}

variable "timeout" {
  type = string
  description = "The Lambda timeout"
}

variable "vertical" {
  type = string
  description = "capterra/getapp/softwareadvice"
}

variable "application" {
  type = string
  description = "name of the application"
}

variable "environment" {
  type = string
  description = "staging/prod"
}

variable "vpc_id" {
  type = string
  description = "VPC in which the lambda must be placed"
}

variable "subnets_for_lambda" {
  type = list
  description = "Subnets in which the lambda must be placed"
  default = []
}

variable "db_user" {
  type = string
  description = "User to be used to access the database"
}

variable "db_service" {
  type = string
  description = "Name of the database service"
}
variable "db_host" {
  type = string
  description = "Database host to be contacted"
}
variable "db_port" {
  type = string
  description = "Database port to connect to"
}
variable "db_stored_procedure" {
  type = string
  description = "Database stored procedure to use"
}
variable "db_password_parameter" {
  type = string
  description = "SSM parameter in which the password is stored"
}

variable "datadog_slack_channel" {
  type = string
  description = "The Slack channel to use to send alarms"
}

variable "is_lambda_trigger_enabled" {
  type = bool
  description = "True to enable SQS to trigger the Lambda function"
}
