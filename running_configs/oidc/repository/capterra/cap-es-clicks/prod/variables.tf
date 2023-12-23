variable "aws_iam_openid_connect_provider_github_arn" {
  type        = string
  description = "OIDC GitHub arn"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "region" {
  type        = string
  description = "Default hosted AWS region"
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring"
}

variable "terraform_managed" {
  type        = bool
  description = "Iac terraform managed"
}

variable "application" {
  type        = string
  description = ""
}

variable "vertical" {
  type        = string
  description = ""
}

variable "product" {
  type        = string
  description = ""
}

variable "environment" {
  type        = string
  description = ""
}

variable "app_contacts" {
  type        = string
  description = ""
}

variable "function" {
  type        = string
  description = ""
}

variable "business_unit" {
  type        = string
  description = ""
}

variable "created_by" {
  type        = string
  description = ""
}

# variable "eks_name" {
#   type        = string
#   description = "Name of the EKS cluster"
# }

# variable "eks_deploy_username" {
#   type        = string
#   description = "Name of the username to map the oidc role in EKS cluster"
# }

# variable "eks_cluster_role" {
#   type        = string
#   description = "The role to be used to create the identity mappings in EKS cluster"
# }
