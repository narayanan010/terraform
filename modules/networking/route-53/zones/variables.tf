variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = map(object({
    domain_name             = string
    comment                 = string
    delegation_set_id       = string
    vpc                     = map(object({
                              id = string
                              region = string
    }))
    force_destroy           = bool
  }))
  default     = {}
}
