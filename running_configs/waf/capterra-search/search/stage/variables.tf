variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  # default     = "arn:aws:iam::350125959894:role/assume-capterra-crf-stg-admin-mfa"
  default = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "application" {
  type        = string
  description = "Name of the application, eg.: crf"
}

variable "web_acl_scope" {
  type        = string
  description = "Name of the waf scope, eg.: CLOUDFRONT, REGIONAL"
}

variable "vertical" {
  type        = string
  description = "Name of the vertical, eg.: capterra"
}

variable "stage" {
  type        = string
  description = "Name of the stage, eg.: staging"
}
