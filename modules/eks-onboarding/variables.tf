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

variable "iam_deployer_role" {
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.iam_deployer_role))
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

variable "eks_iam_role" {
  type        = string
  description = "Main IAM role for the EKS cluster"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.eks_iam_role))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

variable "eks_deployer_role" {
  description = "Assume Role with Admin permissions to deploy EKS resources"

  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.eks_deployer_role))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

######################################################
##  Module Tags variables
######################################################

variable "stage" {
  type        = string
  description = "Stage this resource belongs to (dev/prod/production/prod-dr/production-dr/staging/sandbox)"
  validation {
    condition     = contains(["dev", "prod", "production", "prod-dr", "production-dr", "staging", "sandbox"], lower(var.stage))
    error_message = "The valid values are: dev/prod/production/prod-dr/production-dr/staging/sandbox."
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

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}



variable "namespace_mapping" {
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

variable "ecr_repository_tag_team" {
  type        = map(string)
  description = "Mapping of each namespace with ECR repositories in capterra ORG using tag Team"
  default = {
    "team-services-bx"     = "servicesbx"
    "team-blog"            = "blog"
    "team-crf"             = "crf"
    "team-daylight"        = "daylight"
    "team-gowron"          = "gowron"
    "vendor-info"          = "vx"
    "vendor-notifications" = "vx"
    "vendor-portal"        = "vx"
    "team-orange"          = "orange"
    "team-sauron"          = "sauron"
    "team-frodo"           = "frodo"
    "team-rocket"          = "rocket"
  }
}

variable "github_repositories" {
  type        = map(list(string))
  description = "Mapping of each namespace with GitHub repositories in capterra ORG"
  default = {
    "team-services-bx" = ["capterra/services-ui"]
    "team-blog"        = ["capterra/blog-ui"]
    "team-crf"         = ["gartner-digital-markets/cx-review-*"]
    "team-daylight"    = ["capterra/capterra-graphql", "capterra/bx-api-oracle"]
    "team-gowron"      = ["capterra/all-capone"]
    "vendor-portal"    = ["capterra/vendor-info", "capterra/vendor-portal*", "capterra/vendor-notifications", "capterra/vp-package-template", "capterra/vendor-page-ui", "capterra/vp-frontend-next-js", "capterra/vp-public-api","capterra/organizations","capterra/bidding"]
    "team-frodo"       = ["capterra/cap-es-clicks", "capterra/autobidder", "capterra/clicks-streaming*", "capterra/cap-rbr-py"]
    "team-sauron"      = ["capterra/ga360-uploader", "capterra/upc-consumer"]
    "team-rocket"      = ["capterra/super-team-rocket"]
  }
}


variable "eks_clusters" {
  type        = map(string)
  description = "Mapping of each stage with AWS EKS main clusters"
  default = {
    "dev"           = "capterra-dev-eks"
    "staging"       = "capterra-staging-eks"
    "production"    = "capterra-production-eks"
    "production-dr" = "capterra-production-eks-dr"
  }

  validation {
    condition = (
      alltrue(
        [for rule in keys(var.eks_clusters) : contains(["dev", "staging", "production", "production-dr"], rule)]
    ))
    error_message = "The valid values are: dev / staging / production / production-dr."
  }
}

variable "kms_clusters" {
  type        = map(string)
  description = "Mapping of each stage with AWS KMS keys"
  default = {
    "dev"           = "not-defined"
    "staging"       = "f2d03108-d5ad-4db7-8b3d-2de72e3cdca0"
    "production"    = "5c8ab0dc-f8f5-4760-8b42-7c83fc005f48"
    "production-dr" = "d212578c-5858-48e8-a473-f5d17654c796"
  }
}

variable "route53_hostedzone" {
  type        = map(string)
  description = "Mapping of each stage with Route53 hosted zone"
  default = {
    "dev"           = "Z735WTNG1JTY0"
    "staging"       = "Z735WTNG1JTY0"
    "production"    = "Z30OS86JINAD69"
    "production-dr" = "Z30OS86JINAD69"
  }
}

variable "bootstrap" {
  type        = bool
  description = "Initial infrastructure deployment (bootstrap)"
  default     = true
}