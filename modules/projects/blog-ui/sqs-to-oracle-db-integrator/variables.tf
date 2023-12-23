variable "runtime_lambda" {
  description = "Runtime to be used and its version"
}

variable "cx_oracle_layer_name" {
  description = "The name of cx_oracle layer to be used"
}

variable "memory_size" {
  description = "The amount of memory for the lambda"
}

variable "timeout" {
  description = "The Lambda timeout"
}

variable "vertical" {
  description = "capterra/getapp/softwareadvice"
}

variable "application" {
  description = "name of the application"
}

variable "environment" {
  description = "staging/prod"
}

variable "vpc_id" {
  description = "VPC in which the lambda must be placed"
}

variable "subnets_for_lambda" {
  description = "Subnets in which the lambda must be placed"
  default = []
}

variable "sqs_arn" {
  description = "arn of the queue to get messages"
}

variable "dynamoDB_table_name" {
  description = "name of the dynamoDB table"
}

variable "sqs_id" {
  description = "url of the queue to get messages"
}

variable "db_user" {
}
variable "db_service" {
}
variable "db_host" {
}
variable "db_port" {
}
variable "db_stored_procedure" {
}
variable "db_password_parameter" {
}
variable "is_trigger_enabled" {
  description = "True if the lambda trigger is enabled"
  default = true
}