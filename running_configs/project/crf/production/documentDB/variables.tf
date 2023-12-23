variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  default = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
  #default = "arn:aws:iam::350125959894:role/assume-capterra-crf-stg-admin-mfa"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}