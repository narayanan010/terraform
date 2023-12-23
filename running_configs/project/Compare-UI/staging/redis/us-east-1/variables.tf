variable "modulecaller_source_region" {
	default     = "us-east-1"
  type        = string
	description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_sot_account" {
	default     = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  type        = string
	description = "Assume Role from the account that acts as Source of Truth for AZ-ID. This is capterra-main account"
}

variable "modulecaller_assume_role_deployer_account" {
	default     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  type        = string
	description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

#Tags variables

variable "tag_application" {
  type        = string
  default     = ""
}
variable "tag_app_component" {
  type        = string
  default     = ""
}
variable "tag_function" {
  type        = string
  default     = ""
}
variable "tag_business_unit" {
  type        = string
  default     = ""
}
variable "tag_app_environment" {
  type        = string
  default     = ""
}
variable "tag_app_contacts" {
  type        = string
  default     = "opsteam@capterra.com"
}
variable "tag_created_by" {
  type        = string
  default     = "suman.sindhu@gartner.com"
}
variable "tag_system_risk_class" {
  type        = string
  default     = "3"
}
variable "tag_region" {
  type        = string
  default     = ""
}
variable "tag_network_environment" {
  type        = string
  default     = ""
}
variable "tag_monitoring" {
  type        = string
  default     = ""
}
variable "tag_terraform_managed" {
  type        = string
  default     = "true"
}
variable "tag_vertical" {
  type        = string
  default     = ""
}
variable "tag_product" {
  type        = string
  default     = ""
}
variable "tag_environment" {
  type        = string
  default     = ""
}
