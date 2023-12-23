variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Default Region"
}

variable "modulecaller_dns_r53_zone" {
  default     = "capterra.com."
  type        = string
  description = "Hosted Zone name Value to be passed via Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

##Added below variables to support passing value from outside to module (Especially via Jenkins)

variable "cert_domain_name" {
  description = "cert_domain_name to be passed to module. Eg: faas-examples.capterra.com"
  type        = string
  default     = "faas-examples.capterra.com"
}

variable "stage" {
  description = "stage to be passed to module. Eg: dev, staging, prod etc"
  type        = string
  default     = "prod"
}

variable "waf_arn" {
  description = "ARN of the WAF to be attached to the Cloudfront"
  type        = string 
  default     = ""
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