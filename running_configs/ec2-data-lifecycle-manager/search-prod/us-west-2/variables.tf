variable "modulecaller_source_region" {
  default     = "us-west-2"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  default = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "vertical" {
  default = "capterra"
}