variable "modulecaller_source_region" {
	default = "us-east-1"
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_deployer_account" {
#	default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}

variable "interval" {
}
# Variables for modules. Please refer to module's documentation.
variable "application" {
}
variable "app_component" {
}
variable "function" {
}
variable "business_unit" {
}
variable "app_contacts" {
}
variable "created_by" {
}
variable "system_risk_class" {
}
variable "account_name" {
}
variable "stage" {
}
variable "vertical" {
}
variable "network_environment" {
  description = "Network Env is a reference to the VPC you are building in. MUST be one of fixed values. Eg: [ sandbox | dev | qa | prod ]"
  type        = string
}
variable "product" {
  description = "Name of Product. Eg: capui | gdm etc."
  type        = string
}
variable "app_environment" {
  description = "Could be the same as network environment, except in the case of multiple app environments within a single network environment. (Ex. dev-blue and dev-green within the same dev vpc network environment). Eg: [ sandbox | dev | deva | devb | devdr | ita | itb | qa | pv | prod | poc | training | uat ]"
  type        = string
}
variable "environment" {
  type        = string
  description = "Environment this resource belongs to (dev/prod/prod-dr/staging/sandbox)"
}
