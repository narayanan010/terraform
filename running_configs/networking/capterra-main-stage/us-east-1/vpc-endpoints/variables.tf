variable "modulecaller_source_region" {
	type = string
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
	type = string
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}

variable "vertical" {
	type = string
}

variable "vpc_id" {
  	type = string
	description = "The VPC in which the Elastic Endpoint is created."
}

variable "elastic_vpc_endpoint_subnet_ids" {
  	type = list(string)
	description = "The Subnets in which the Elastic Endpoint ENI is created."
}

variable "datadog_vpc_endpoint_subnet_ids" {
  	type = list(string)
	description = "The Subnets in which the Datadog Endpoint ENI is created."
}

variable "sqs_vpc_endpoint_subnet_ids" {
  	type = list(string)
	description = "The Subnets in which the SQS Endpoint ENI is created."
}