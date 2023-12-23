variable "modulecaller_source_region" {
	default = "us-east-1"
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
	default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
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
