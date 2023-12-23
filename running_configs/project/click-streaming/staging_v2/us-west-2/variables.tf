variable "msk_cluster_name" {
  type        = string
  description = "Name of the MSK cluster"
}

variable "msk_kafka_version" {
  type        = string
  description = "Desired Kafka software version"
}

variable "msk_number_of_broker_nodes" {
  type        = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
}

variable "msk_broker_instance_type" {
  type        = string
  description = "The instance type to use for the kafka brokers"
}

variable "msk_broker_ebs_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "msk_broker_client_subnets" {
  type        = list(any)
  description = "A list of subnets to connect to in client VPC"
}


variable "msk_cw_logs_retention" {
  type        = number
  description = "MSK CloudWatch log group retention in days"
}

variable "region" {
  type        = string
  description = "Default hosted AWS region"
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring"
}

variable "terraform_managed" {
  type        = bool
  description = "Iac terraform managed"
}

variable "application" {
  type        = string
  description = ""
}

variable "vertical" {
  type        = string
  description = ""
}

variable "product" {
  type        = string
  description = ""
}

variable "environment" {
  type        = string
  description = ""
}

variable "app_contacts" {
  type        = string
  description = ""
}

variable "function" {
  type        = string
  description = ""
}

variable "business_unit" {
  type        = string
  description = ""
}

variable "created_by" {
  type        = string
  description = ""
}

variable "system_risk_class" {
  type        = string
  description = ""
}

variable "app_component" {
  type        = string
  description = ""
}

variable "alerts_to" {
  type        = string
  description = "Default target for alerts"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}
