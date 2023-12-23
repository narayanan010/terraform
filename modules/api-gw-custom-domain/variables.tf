# Bucket Variables and other vars.
variable "region_aws" {
	description = "This is region where tf template is to be deployed"
 	default     = "us-east-1"
}

variable "namespace" {
    type = string
    default = "gdm"
}

variable "name" {
    type = string
    description = "Name of application. E.g: serverlessapp"    
}

variable "stage" {
    type = string
    description = "stage this resource belongs to (Dev/Prod/Stg/sandbox)"
} 

variable "vertical" {
    type = string
    description = "Vertical this resource belongs to (Capterra/GetApp/SoftwareAdvice)"
    default = "capterra"
}


#ACM Variables

variable cert_validation_type {
    description = "this is the type of cert validation to be used. Valid values are DNS, EMAIL"
    type = "string"
    default = "DNS"
}

variable "cert_hosted_zone_name" {
  description = "Name of the Hosted Zone where the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g capstage.net."
  type = "string"
}

#R53 Variables

variable "r53_dns_ttl" {
    type = "string"
    description = "r53_dns_ttl is ttl for dns record"
    default = "90"
}


variable "hosted_zone_id" {
  type        = string
  description = "Route 53 Zone ID for DNS validation records"
}


#API-GW Variables

variable "apigw_custom_domain_name" {
    type = "string"
    description = "apigw_custom_domain_name is custom domain name for API GW. This is also the domain that needs to be whitelisted. Format e.g dd.capstage.net"
}

variable "apgdn_types" {
    type = "string"
    description = "apgdn_types is type. This resource currently only supports managing a single value. Valid values: EDGE or REGIONAL. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions."
    default = "EDGE"  
}

variable "apigw_security_policy" {
    type = "string"
    description = "apigw_security_policy is type of TLS. The Transport Layer Security (TLS) version + cipher suite for this DomainName. The valid values are TLS_1_0 and TLS_1_2. Must be configured to perform drift detection."
    default = "TLS_1_2"
}

variable "api_id" {
    type = "string"
    description = "The ID of the REST API to be associated. Eg: rtd7ydou0m"
}

variable "api_stage_name" {
    type = "string"
    description = "The stage name of the REST API to be associated. Eg: staging , prod"
}



##Tags

#tags. These values can be overwritten when calling module.
variable tag_application {
    type = "string"
    default = ""
}
variable tag_app_component {
    type = "string"
    default = ""
}
variable tag_function {
    type = "string"
    default = ""
}
variable tag_business_unit {
    type = "string"
    default = ""
}
variable tag_app_environment {
    type = "string"
    default = ""
}
variable tag_app_contacts {
    type = "string"
    default = "opsteam@capterra.com"
}
variable tag_created_by {
    type = "string"
    default = "sarvesh.gupta/colin.taras@gartner.com"
}
variable tag_system_risk_class {
    type = "string"
    default = "3"
}
variable tag_region {
    type = "string"
    default = ""
}
variable tag_network_environment {
    type = "string"
    default = ""
}
variable tag_monitoring {
    type = "string"
    default = ""
}
variable tag_terraform_managed {
    type = "string"
    default = "true"
}
variable tag_vertical {
    type = "string"
    default = ""
}
variable tag_product {
    type = "string"
    default = ""
}
variable tag_environment {
    type = "string"
    default = ""
}
