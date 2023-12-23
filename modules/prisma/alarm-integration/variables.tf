variable "app_component" {
  type        = string
  description = "Breakdown of the functional parts ('components' or 'subservices') that make up an application. Grouping is based more on function than underlying technology. For example Alfresco components could be Share, Repository, Solr, and Transformation. GCOM components could be gproduct, gsearch, recengine, etc. If there are replicas of a given component ('blue/green', 'side-a/side-b') these should be tagged as independent app components. Ex: 'search_solr_a' and 'search_solr_b'. Underlying services that work together to make up a component should be tagged with the same app_component tag, for example, loadbalancers, ASGs, and DBs for gsearch would have the same app_component tag: gsearch. Eg: search, gmarket, appcache"
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  default     = "capterra"
}

variable "product" {
  type        = string
  description = "Name of Product. Eg: capui | gdm etc."
}

variable "environment" {
  type        = string
  description = "Environment this resource belongs to (dev/prod/prod-dr/staging/sandbox)"
  default     = "prod"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 345600
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys"
  default     = true
}