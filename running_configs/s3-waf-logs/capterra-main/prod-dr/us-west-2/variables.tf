variable "modulecaller_source_region" {
	default = "us-west-2"
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
	default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}

# Variables for modules. Please refer to module's documentation.

variable "account_name" {
}
variable "stage" {
}
variable "vertical" {
}

##Tags

#tags. These values can be overwritten when calling module.
variable "tag_application" {
  type    = string
  default = ""
}
variable "tag_app_component" {
  type    = string
  default = ""
}
variable "tag_function" {
  type    = string
  default = ""
}
variable "tag_business_unit" {
  type    = string
  default = ""
}
variable "tag_app_environment" {
  type    = string
  default = ""
}
variable "tag_app_contacts" {
  type    = string
  default = "opsteam@capterra.com"
}
variable "tag_created_by" {
  type    = string
  default = "fabio.perrone@gartner.com"
}
variable "tag_system_risk_class" {
  type    = string
  default = "3"
}
variable "tag_region" {
  type    = string
  default = ""
}
variable "tag_network_environment" {
  type    = string
  default = ""
}
variable "tag_monitoring" {
  type    = string
  default = ""
}
variable "tag_terraform_managed" {
  type    = string
  default = "true"
}
variable "tag_vertical" {
  type    = string
  default = ""
}
variable "tag_product" {
  type    = string
  default = ""
}
variable "tag_environment" {
  type    = string
  default = ""
}