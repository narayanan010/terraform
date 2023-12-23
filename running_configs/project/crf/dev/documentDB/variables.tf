variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  #default = "arn:aws:iam::377773991577:role/gdm-admin-access"
  default = "arn:aws:iam::377773991577:role/capterra-admin-role"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}