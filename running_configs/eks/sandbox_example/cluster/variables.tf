######################################################
##  AWS provider variables
######################################################

variable "region" {
  type        = string
  description = "Default hosted AWS region"
}

variable "region_landing" {
  type        = string
  description = "Default landing AWS region"
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring"
}

variable "terraform_managed" {
  type        = bool
  description = "Iac terraform managed"
}


# ######################################################
# ##  EKS cluster variables
# ######################################################

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"
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

# variable "technology" {
#   type        = string
#   description = ""
# }

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

# variable "platform" {
#   type        = string
#   description = ""
# }

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
