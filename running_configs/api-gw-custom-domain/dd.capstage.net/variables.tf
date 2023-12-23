variable "modulecaller_source_region" {
	default = "us-east-1"
	description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_dns_r53_zone" {
	default = "capstage.net."
	description = "Hosted Zone name Value to be passed via Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

variable "modulecaller_assume_role_primary_account" {
	default = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer"
	description = "Assume Role from the account that holds API GW Domain Name, ACM Cert, etc"
}

variable "modulecaller_assume_role_dns_account" {
	default = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
	description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly)"
}


##Added below variables to support passing value from outside to module (Especially via Jenkins)

variable "apigw_custom_domain_name" {
	description = "apigw_custom_domain_name to be passed to module. Eg: dd.capstage.net"
}

variable "stage" {
	description = "stage to be passed to module. Eg: dev, staging etc"
}

variable "api_id" {
    type = "string"
    description = "The ID of the REST API to be associated. Eg: rtd7ydou0m"
}

variable "api_stage_name" {
    type = "string"
    description = "The stage name of the REST API to be associated. Eg: staging , prod"
}