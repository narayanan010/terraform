# Deploy
variable "modulecaller_source_region" {
  type        = string
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  #type        = string
  type        = map(string)
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
  default = {
    "dev"       = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"
    "staging"   = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
    "prod"      = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"
  }
}

variable "modulecaller_assume_role_ecs_deployer" {
  type        = map(string)
  description = "Assume Role for ECS task Deployment"
  default = {
    "dev"       = "arn:aws:iam::148797279579:role/github-actions-user-workspace-dev"
    "staging"   = "arn:aws:iam::273213456764:role/github-actions-user-workspace-staging"
    "prod"      = "arn:aws:iam::296947561675:role/github-actions-user-workspace-prod"
  }
}

variable "task_memory" {
  type        = map(string)
  description = "Task memory used per environment"
  default = {
    "dev"       = 256
    "staging"   = 512
    "prod"      = 1024
  }
}

variable "cw_logs_retention" {
  type        = map(string)
  description = "Task memory used per environment"
  default = {
    "dev"       = 1
    "staging"   = 14
    "prod"      = 30
  }
}


# Tags
variable "tag_application" {
  type        = string
  description = "Application name; a unifying name for the system involved. Must be globally unique across ALL of Gartner (there is only one 'gcom'), and must be uniform across all components of the app (all of these components are parts of the 'gcom' application). Must use only lowercase characters, numbers or hyphens. No uppercase, underscores, whitespaces or special characters. Eg: aem, sugar, cppdocs, gcom"
}

variable "tag_app_component" {
  type        = string
  description = "Breakdown of the functional parts ('components' or 'subservices') that make up an application. Grouping is based more on function than underlying technology. For example Alfresco components could be Share, Repository, Solr, and Transformation. GCOM components could be gproduct, gsearch, recengine, etc. If there are replicas of a given component ('blue/green', 'side-a/side-b') these should be tagged as independent app components. Ex: 'search_solr_a' and 'search_solr_b'. Underlying services that work together to make up a component should be tagged with the same app_component tag, for example, loadbalancers, ASGs, and DBs for gsearch would have the same app_component tag: gsearch. Eg: search, gmarket, appcache"
}

variable "tag_function" {
  type        = string
  description = "Used to identify function of server or resource (app layer). Eg: [ appserver | automation | batchserver | cache | cdn | dbserver | ecs-node | eks-master | eks-node | loadbalancer | proxy | webserver ]"
}

variable "tag_business_unit" {
  type        = string
  description = "The IT business unit paying for this application out of their budget, in lowercase. Eg: [ cbs | da | dm | emt | itio | ls | pdo | rcd | sat | secops | ssd |svc | ta | tn ]"
}

variable "tag_app_contacts" {
  type        = string
  description = "Application team DL with @gartner.com removed (local-part only). I.e: If your DL is MyDL@gartner.com, the value would be 'mydl'. Eg: dlitcloudops"
  default     = "opsteam@capterra.com"
}

variable "tag_created_by" {
  type        = string
  description = "Email address of person creating infrastructure (typically the person who writes the Terraform). Eg: colin.taras@gartner.com , sarvesh.gupta@gartner.com"
}

variable "tag_system_risk_class" {
  type        = string
  description = "Please review our System Risk Classification page to determine whether your application is 1, 2 or 3. Here at: 'https://gartner.atlassian.net/wiki/spaces/CLOUDCOE/pages/2061665133/System+Risk+Classification' . Eg: [ 1 | 2 | 3 ...]"
  default     = "2"
}

variable "tag_region" {
  type        = string
  description = "Region name such as us-east-1, us-west-2, ..."
}

variable "tag_monitoring" {
  type        = string
  description = "Set as true for monitoring. If a tag is set 'monitoring:false' monitoring will not be provided to this AWS object Eg: true | false"
}

variable "tag_terraform_managed" {
  type        = string
  description = "Set as true for tf managed reesources. Valid Values: true | false"
  default     = "true"
}

variable "tag_vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  default     = "capterra"
}

# ECR Repository
variable "encryption_type" {
  type        = string
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256."
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "The valid values are: AES-256, KMS."
  }
}

variable "ecr_image_uri" {
  type        = string
  description = "URI of image in use"
}

# VPC variables

variable "ecs_task_environment_file" {
  type = string
}

variable "ecs_task_secrets_file" {
  type = string
}
