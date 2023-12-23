variable "region" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "account_name" {
  description = "This is the name of the account: main, search, crf."
}

variable "stage" {
  type        = string
  description = "Stage this resource belongs to (dev/prod/prod-dr/staging/sandbox)"
  validation {
    condition     = contains(["prod", "prod-dr", "staging", "dev", "sandbox"], var.stage)
    error_message = "The valid values are: dev/prod/staging/sandbox."
  } 
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  validation {
    condition     = contains(["capterra", "getapp", "softwareadvice"], var.vertical)
    error_message = "The valid values are: capterra/getapp/softwareadvice."
  } 
}
