variable "modulecaller_source_region" {
  type        = string
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "cname_aliases" {
  type        = list(string)
  description = "List of CNAMEs to be associated with the Cloudfront distribution."
  default     = []
}

variable "default_origin_dns" {
  type        = string
  description = "The origin dns to be associated with the default behaviour of Cloudfront distribution"
}

variable "secret_header_value" {
  type        = string
  description = "The secret value to be associated with header X-CF-Confirmed-Header that Cloudfront will forward to the Origin"
}

variable "hosted_zone_id" {
  type        = string
  description = "The hosted zone in which the entry dns should be added."
}

variable "web_acl_arn" {
  type        = string
  description = "The ARN of the WAF to be associated with the Cloudfront distribution"
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to be associated with the Cloudfront distribution"
}
