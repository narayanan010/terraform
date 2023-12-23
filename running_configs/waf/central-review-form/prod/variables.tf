variable "modulecaller_source_region" {
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
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
