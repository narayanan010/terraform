#Basic Variables
variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_sot_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account that acts as Source of Truth for AZ-ID. This is capterra-main account"
}

variable "modulecaller_assume_role_deployer_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
} 