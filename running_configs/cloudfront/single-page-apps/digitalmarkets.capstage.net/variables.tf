variable "cf_forward_query_string" {
    default =   "false"
    description = "Forward query string to the origin that is associated with this cache behavior"
}

variable "cf_forward_header_values" {
     type = list
     description = "A list of whitelisted header values to send to origin server"
     default     = ["Origin" , "Access-Control-Request-Method" , "Access-Control-Request-Headers"]
 }

variable "origin_id"{
    default =   "origin-s3-vp-frontend-staging"
    description = "Name of origin id"    
}
variable "cdn_max_ttl" {
    type = string
    default = "31536000"
}

variable "cdn_min_ttl" {
    type = string
    default = "0"
}

variable "cdn_default_ttl" {
    type = string
    default = "86400"
}

variable "custom_max_ttl" {
    type = string
    default = "31536000"
}

variable "custom_min_ttl" {
    type = string
    default = "0"
}

variable "custom_default_ttl" {
    type = string
    default = "86400"
}

variable "cf_minimum_protocol_version" {
    type = string
    description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016, TLSv1.2_2018, or TLSv1.2_2019."
    default = "TLSv1.2_2019"
}

variable "cf_alias" {
  type        = list(string)
  description = "Other domain aliases to add to the CloudFront distribution other than main ones. Format to pass multiple aliases e.g: [alias-2,alias3] each in double quotes."
  default     = ["digitalmarkets.capstage.net"]
}

variable "cf_viewer_protocol_policy" {
    type = string
    description = "Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https."
    default = "redirect-to-https"
}

variable "cf_price_class" {
    type = string
    description = "The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
    default = "PriceClass_All"
}

variable "acm_cert_arn" {
    type = string
    description = "acm cert to associate to cf-distro"
    default = "arn:aws:acm:us-east-1:176540105868:certificate/e2d2596c-5f84-4310-b865-97912d0a8e9a"
}

variable "s3_regional_domain_name" {
    type = string
    description = "detailed address of bucket"
    default = "vp-frontend-staging.s3.amazonaws.com"
}

variable "oai_id" {
    type = string
    description = "OAI to be associated with origin"
    default = "origin-access-identity/cloudfront/E2E2IQA0J29DL5"
}

variable "waf_acl_arn" {
    type = string
    description = "ACL ID to be associated with cloudfront distro"
    default = "arn:aws:wafv2:us-east-1:176540105868:global/webacl/capterra-waf-acl-glbl/f6e66fd6-37cc-42fb-9a8b-e840ba29c5af"
}


variable "hosted_zone_id" {
    type = string
    description = "Hosted zone id where R53 record is to be created"
    default = "Z735WTNG1JTY0"
}

variable "acm_cert_domain" {
    type = string
    description = "Hosted zone id where R53 record is to be created"
    default = "digitalmarkets.capstage.net"
}

variable "r53_dns_ttl" {
    type = string
    description = "r53_dns_ttl is ttl for dns record"
    default = "90"
}


variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  default     = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
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
  default = "sarvesh.gupta@gartner.com"
}
variable "tag_system_risk_class" {
  type    = string
  default = ""
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