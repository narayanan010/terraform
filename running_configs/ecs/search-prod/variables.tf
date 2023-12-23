# Deploy
variable "modulecaller_source_region" {
  type        = string
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "modulecaller_assume_role_ecs_deployer" {
  type        = string
  description = "Assume Role for ECS task Deployment"
}

variable "modulecaller_assume_role_dns_account" {
  type        = string
  description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly)"
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

variable "tag_app_environment" {
  type        = string
  description = "Could be the same as network environment, except in the case of multiple app environments within a single network environment. (Ex. dev-blue and dev-green within the same dev vpc network environment). Eg: [ sandbox | dev | deva | devb | devdr | ita | itb | qa | pv | prod | poc | training | uat ]"
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

variable "tag_network_environment" {
  type        = string
  description = "Network Env is a reference to the VPC you are building in. MUST be one of fixed values. Eg: [ sandbox | dev | qa | prod ]"
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

variable "tag_product" {
  type        = string
  description = "Name of Product. Eg: capui | gdm etc."
}

variable "tag_environment" {
  type        = string
  description = "Environment this resource belongs to (dev/prod/prod-dr/staging/sandbox)"
}

# ASG Group
variable "asg_desired_capacity" {
  type        = number
  description = "EC2 instances for Autoscaling Group"
  default     = 3
}

# VPC variables

variable "vpc_id" {
  type        = string
  description = "VPC id of exiting resource"
}

# CloudWatch variables
variable "cw_logs_retention" {
  type        = string
  description = ""
}

# Route53
variable "modulecaller_dns_r53_hostedzone" {
  type        = string
  description = "Hosted Zone name Value to be passed via Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

# Kinesis
variable "datadog_http_endpoint" {
  type        = string
  description = "The HTTP endpoint URL to which Kinesis Firehose sends your data"
}