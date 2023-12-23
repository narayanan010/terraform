variable "modulecaller_source_region" {
	default = "us-east-1"
	description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
	default = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
	description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}

variable "vertical" {
  default = "capterra"
}
