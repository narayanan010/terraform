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
  	type = list
	description = "The VPC to be associated with Hosted zone is created."
}

variable "vpc_region" {
	type = list
	description = "REGION of the associated VPC from vpc_id variable."
}

variable "record_dns_value_gdm-bids-global-prod" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-bxapi-global-prod" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-bxapi-global-prod-dr" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-vxautobidder-global-prod" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-gdm-vxautobidder-global-prod-dr" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-gdm-vxautobidder-global-prod-dr-ro" {
	type = list
	description = "Value of target to point to"
}

variable "record_dns_value_gdm-gdm-bxapi-global-prod-ro" {
	type = list
	description = "Value of target to point to"	
}