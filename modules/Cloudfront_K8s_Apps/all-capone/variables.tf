variable "is_logging_enabled" {
    type = bool
    description = "Set to true to enable logging of the Cloudfront distribution."
    default = false
}

variable "bucket_logging" {
    type = string
    description = "The bucket to which the logs are sent from the Cloudfront distribution."
    default = ""
}

variable "bucket_prefix_logging" {
    type = string
    description = "The prefix that logging objects will have in the logging bucket."
    default = ""
}

variable "cname_aliases" {
    type = list(string)
    description = "List of CNAMEs to be associated with the Cloudfront distribution."
    default = []
}

variable "acm_certificate_arn" {
    type = string
    description = "The ARN of the ACM certificate to be used."
    default = ""
}

variable "default_origin_dns" {
    type = string
    description = "The origin dns to be associated with the default behaviour of Cloudfront distribution"
}

variable "secret_header_value" {
    type = string
    description = "The secret value to be associated with header X-CF-Confirmed-Header that Cloudfront will forward to the Origin"
}

variable "web_acl_arn" {
    type = string
    description = "The ARN of the WAF to be associated with the Cloudfront distribution"
    default = ""
}
