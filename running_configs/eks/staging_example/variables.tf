######################################################
##  AWS provider variables
######################################################

variable "region" {
  type        = string
  description = "AWS region where new services are hosted"
}

variable "region_landing" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where onboarding services are hosted"
}

variable "iam_deployer_role_arn" {
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.iam_deployer_role_arn))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}



######################################################
##  EKS cluster variables
######################################################

variable "namespace" {
  type        = string
  description = "Namespace to be created. E.G.: team-services-bx"
}

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_cluster_iam_role_arn" {
  type        = string
  description = "Main IAM role for manage the EKS cluster"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.eks_cluster_iam_role_arn))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

variable "eks_deployer_role_arn" {
  description = "Assume Role with Admin permissions to deploy EKS resources"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.eks_deployer_role_arn))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

######################################################
##  Module Tags variables
######################################################

variable "application" {
  type        = string
  description = ""
}

variable "terraform_managed" {
  type        = bool
  description = ""
}

variable "monitoring" {
  type        = bool
  description = ""
}

variable "app_component" {
  type        = string
  description = ""
}

variable "technology" {
  type        = string
  description = ""
}

variable "stage" {
  type        = string
  description = "Stage this resource belongs to (dev/prod/staging/sandbox)"
  validation {
    condition     = contains(["prod", "staging", "sandbox"], var.stage)
    error_message = "The valid values are: prod/staging."
  }
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  default     = "capterra"
  validation {
    condition     = contains(["capterra", "getapp", "softwareadvice"], var.vertical)
    error_message = "The valid values are: capterra/getapp/softwareadvice."
  }
}

variable "platform" {
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

variable "system_risk_class" {
  type        = string
  description = ""
}

# Enable settings
variable "team_settings" {
  type = list(object({
    ecr_repository    = optional(string)
    github_repository = optional(list(string))
    eks_cluster = optional(object({
      kms        = optional(string)
      hostedzone = optional(string)
    }), {})
  }))
  description = "Define namespace and environment parameteters"
  default     = []
}

variable "bootstrap" {
  type        = bool
  description = "Initial infrastructure deployment (bootstrap)"
  default = false
}