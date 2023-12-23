##Gartner Variables as per standard, Refer Link: https://confluence.gartner.com/pages/viewpage.action?pageId=139892570##

variable "application" {
  description = "Application name; a unifying name for the system involved. Must be globally unique across ALL of Gartner (there is only one 'gcom'), and must be uniform across all components of the app (all of these components are parts of the 'gcom' application). Must use only lowercase characters, numbers or hyphens. No uppercase, underscores, whitespaces or special characters. Eg: aem, sugar, cppdocs, gcom"
  type        = string
}


variable "app_component" {
  description = "Breakdown of the functional parts ('components' or 'subservices') that make up an application. Grouping is based more on function than underlying technology. For example Alfresco components could be Share, Repository, Solr, and Transformation. GCOM components could be gproduct, gsearch, recengine, etc. If there are replicas of a given component ('blue/green', 'side-a/side-b') these should be tagged as independent app components. Ex: 'search_solr_a' and 'search_solr_b'. Underlying services that work together to make up a component should be tagged with the same app_component tag, for example, loadbalancers, ASGs, and DBs for gsearch would have the same app_component tag: gsearch. Eg: search, gmarket, appcache"
  type        = string
}

variable "function" {
  description = "Used to identify function of server or resource (app layer). Eg: [ appserver | automation | batchserver | cache | cdn | dbserver | ecs-node | eks-master | eks-node | loadbalancer | proxy | webserver ]"
  type        = string
}

variable "business_unit" {
  description = "The IT business unit paying for this application out of their budget, in lowercase. Eg: [ cbs | da | dm | emt | itio | ls | pdo | rcd | sat | secops | ssd |svc | ta | tn ]"
  type        = string
}

variable "app_environment" {
  description = "Could be the same as network environment, except in the case of multiple app environments within a single network environment. (Ex. dev-blue and dev-green within the same dev vpc network environment). Eg: [ sandbox | dev | deva | devb | devdr | ita | itb | qa | pv | prod | poc | training | uat ]"
  type        = string
}

variable "app_contacts" {
  description = "Application team DL with @gartner.com removed (local-part only). I.e: If your DL is MyDL@gartner.com, the value would be 'mydl'. Eg: dlitcloudops"
  type        = string
}

variable "created_by" {
  description = "Email address of person creating infrastructure (typically the person who writes the Terraform). Eg: colin.taras@gartner.com , sarvesh.gupta@gartner.com"
  type        = string
}

variable "system_risk_class" {
  description = "Please review our System Risk Classification page to determine whether your application is 1, 2 or 3. Here at: 'https://confluence.gartner.com/display/CLOUDCOE/System+Risk+Classification' . Eg: [ 1 | 2 | 3 ...]"
  type        = number
  # validation {
  #   condition     = var.system_risk_class >= 1 && var.system_risk_class <= 3 && floor(var.system_risk_class) == var.system_risk_class
  #   error_message = "Accepted values: [1-3] and must be an integer."
  # }
}

variable "region" {
  type        = string
  description = "Environment name such as us-east-1, us-west-2, ..."

  # validation {
  #   condition     = var.region == null ? true : contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2", "af-south-1", "ap-east-1", "ap-south-1", "ap-northeast-3", "ap-northeast-2", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "eu-south-1", "eu-west-3", "eu-north-1", "me-south-1", "sa-east-1"], var.region)
  #   error_message = "Only one string valid AWS region names are expected here such as us-east-1, us-west-2 ..."
  # }
}

variable "network_environment" {
  description = "Network Env is a reference to the VPC you are building in. MUST be one of fixed values. Eg: [ sandbox | dev | qa | prod ]"
  type        = string
  # validation {
  #   condition     = contains(["sandbox", "dev", "qa", "staging", "prod", "production"], var.network_environment)
  #   error_message = "The valid values are: sandbox/dev/qa/staging/prod/production."
  # }
}
variable "monitoring" {
  description = "Set as true for monitoring. If a tag is set 'monitoring:false' monitoring will not be provided to this AWS object Eg: true | false"
  type        = string
  default     = true
}


##Capterra Standard Variables##

variable "terraform_managed" {
  description = "Set as true for tf managed reesources. Valid Values: true | false"
  type        = string
  default     = true
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"

  # validation {
  #   condition     = contains(["capterra", "getapp", "softwareadvice", "gdm", "sa"], var.vertical)
  #   error_message = "The valid values are: capterra/getapp/softwareadvice/gdm/sa."
  # }
}

variable "product" {
  description = "Name of Product. Eg: capui | gdm etc."
  type        = string
}
variable "environment" {
  type        = string
  description = "Environment this resource belongs to (dev/prod/prod-dr/staging/sandbox)"
  # validation {
  #   condition     = contains(["dev", "prod", "production", "prod-dr", "staging", "sandbox"], lower(var.environment))
  #   error_message = "The valid values are: dev/prod/production/prod-dr/staging/sandbox in lowercase."
  # }
}
variable "tags" {
  description = "Additional tags to be passed when calling module (e.g. `tags = {'Business' = 'XYZ', 'Snapshot' = 'true'}`"
  type        = map(string)
  default     = {}
}
variable "context" {
  type = any
  default = {
    application         = {}
    app_component       = {}
    function            = {}
    business_unit       = {}
    app_environment     = {}
    app_contacts        = {}
    created_by          = {}
    system_risk_class   = {}
    region              = {}
    network_environment = {}
    monitoring          = {}
    terraform_managed   = {}
    vertical            = {}
    product             = {}
    environment         = {}
  }
}