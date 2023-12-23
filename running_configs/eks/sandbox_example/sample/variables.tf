######################################################
##  AWS provider variables
######################################################

variable "region" {
  type        = string
  description = "Default hosted AWS region where new services were deployed"
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring"
}

variable "terraform_managed" {
  type        = bool
  description = "Iac terraform managed"
}

variable "iam_deployer_role_arn" {
  type        = string
  description = "AWS Assume Role from the deployer account"
}


# ######################################################
# ##  EKS cluster variables
# ######################################################

variable "namespace" {
  type        = string
  description = "Namespace to be created. E.G.: team-services-bx"
}

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"
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
