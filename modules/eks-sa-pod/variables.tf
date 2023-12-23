variable "provider_url" {
  description = "URL of the OIDC Provider"
  type        = string
}

variable "project_name" {
  description = "Name of the application for which this role will be created. Example - 'blog-ui'"
  type        = string
}

variable "env" {
  description = "Environment for which this role will be created. Example - 'prod', 'stage'"
  type        = string
  default     = "dev"
}

variable "namespace" {
  description = "Namespace of the application for which this role will be created. Example - 'team-blog'"
  type        = string
  default     = "default"
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "inline_policy" {
  description = "Json with inline policy to assign to the role."
  type        = string
  default     = ""
}