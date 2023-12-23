variable "modulecaller_source_region" {
  default     = "eu-west-3"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "vertical" {
  default = "capterra"
}