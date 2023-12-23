variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

#ACM Variables
variable "cert_domain_name" {
  type        = string
  description = "This is certificate domain that needs to be whitelisted. Format e.g sa-ppl-form-dr.capterra.com"
  default = "sitemaps.capstage.net"
}

variable "cert_validation_type" {
  description = "this is the type of cert validation to be used. Valid values are DNS, EMAIL"
  type        = string
  default     = "DNS"
}

variable "cert_hosted_zone_name" {
  description = "Name of the Hosted Zone where the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g capstage.net."
  type        = string
  default = "capstage.net."
}

#R53 Variables

variable "r53_dns_ttl" {
    type = string
    description = "r53_dns_ttl is ttl for dns record"
    default = "90"
}

variable "cf_aliases" {
  type        = list(string)
  description = "Other domain aliases to add to the CloudFront distribution other than main ones. Format to pass multiple aliases e.g: [alias-2,alias3] each in double quotes."
  default     = []
}

variable "cf_price_class" {
    type = string
    description = "The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
    default = "PriceClass_All"
}

variable "wafID" {
    type = string
    description = "Input the name of the WAF web acl created."
    default = "arn:aws:wafv2:us-east-1:176540105868:global/webacl/capterra-security-main-global-staging-waf/03676c8f-a0b0-4c77-9036-df2de803dcc5"
}

variable "cf_minimum_protocol_version" {
    type = string
    description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018."
    default = "TLSv1.2_2021"
}

variable "modulecaller_dns_r53_zone" {
  default = "capstage.net."
  description = "Hosted Zone name Value to be passed to Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

#tags. These values can be overwritten when calling module.

variable "tag_application" {
  type    = string
  default = "sitemaps"
}
variable "tag_app_component" {
  type    = string
  default = "cloudfront"
}
variable "tag_function" {
  type    = string
  default = "cloudfront"
}
variable "tag_business_unit" {
  type    = string
  default = "gdm"
}
variable "tag_app_environment" {
  type    = string
  default = "staging"
}
variable "tag_app_contacts" {
  type    = string
  default = "capterra_devops"
}
variable "tag_created_by" {
  type    = string
  default = "yajush.garg@gartner.com"
}
variable "tag_system_risk_class" {
  type    = string
  default = "3"
}
variable "tag_region" {
  type    = string
  default = "us-east-1"
}
variable "tag_network_environment" {
  type    = string
  default = "staging"
}
variable "tag_monitoring" {
  type    = string
  default = "false"
}
variable "tag_terraform_managed" {
  type    = string
  default = "true"
}
variable "tag_vertical" {
  type    = string
  default = "capterra"
}
variable "tag_product" {
  type    = string
  default = "sitemaps"
}
variable "tag_environment" {
  type    = string
  default = "staging"
}

variable "ordered_cache_behavior_default_ttl" {
  type        = string
  description = "The default_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "600"
}

variable "ordered_cache_behavior_min_ttl" {
  type        = string
  description = "The min_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "0"
}

variable "ordered_cache_behavior_max_ttl" {
  type        = string
  description = "The max_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "31536000"
}

variable "ordered_cache_behavior_viewer_protocol_policy" {
  type        = string
  description = "Viewer Protocol policy for ordered cache behavior. Valid values are One of: allow-all, https-only, or redirect-to-https."
  default     = "redirect-to-https"
}