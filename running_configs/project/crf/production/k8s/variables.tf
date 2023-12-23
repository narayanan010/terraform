variable "modulecaller_source_region" {
  type        = string
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  default     = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "vertical" {
  type        = string
  description = "capterra/getapp/softwareadvice"
}

variable "application" {
  type        = string
  description = "name of the application"
}

variable "environment" {
  type        = string
  description = "staging/prod"
}

variable "namespace" {
  type        = string
  description = "generally team-$team_name"
}

variable "oidc_provider_url" {
  type        = string
  description = "Provider URL of OIDC from EKS cluster"
}

variable "team_tag" {
  type        = list(string)
  description = "Value for tag Team to be used for accessing the resources."
}
