variable "modulecaller_source_region" {
   default     = "us-east-1"
   description = "Region to be passed to Provider info where calling module"
 }

 variable "modulecaller_assume_role_deployer_account" {
   default = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
   description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
 } 