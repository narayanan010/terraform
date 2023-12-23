variable "modulecaller_source_region" {
	type = string
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
	type = string
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}

variable "modulecaller_assume_role_authorized_account" {
	type = string
	description = "Assume Role for the account that needs to be authorized with Hosted Zone"
}

variable "vertical" {
	type = string
}

variable "vpc_id" {
  	type = string
	description = "The VPC to be associated with Hosted zone is set via this var."
}

variable "authorized_vpc_id" {
	type = string
	description = "The VPC to be authorized with the Hosted zone is set via this var."
	default = ""
}

variable "zone_id" {
	type = string
	description = "The Hosted Zone ID to be associated with VPC Authorization resource."
	default = ""
}

variable "record_dns_value" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-bids-global-stg" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-vx-autobidder-global-stg" {
	type = list
	description = "Value of target to point to"
}