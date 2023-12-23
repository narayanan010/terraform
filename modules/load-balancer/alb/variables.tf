# Security Group Vars

variable "create_sg" {
  description = "Boolean to check if Security group is to be created"
  type        = bool
  default     = true
}

variable "create_sg_ingress_cidr" {
  description = "Boolean to check if Security Group Ingress CIDR rules are to be created"
  type        = bool
  default     = true
}

variable "create_sg_ingress_source_sg" {
  description = "Boolean to check if Security Group Ingress with Source Sec Grp ID rules are to be created"
  type        = bool
  default     = false
}

variable "create_sg_ingress_self" {
  description = "Boolean to check if Security Group Ingress Self rules are to be created"
  type        = bool
  default     = false
}

variable "create_sg_egress_cidr" {
  description = "Boolean to check if Security Group Egress CIDR rules are to be created"
  type        = bool
  default     = true
}

variable "create_sg_egress_source_sg" {
  description = "Boolean to check if Security Group Egress with Source Sec Grp ID rules are to be created"
  type        = bool
  default     = false
}

variable "create_sg_egress_self" {
  description = "Boolean to check if Security Group Egress Self rules are to be created"
  type        = bool
  default     = false
}

variable "alb_sg_name" {
  description = "ALB Security Group name"
  type        = string
}

variable "sg_ingress_rules_cidr" {
  description = "Ingress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = []
}

variable "sg_ingress_rules_source_sg" {
  description = "Ingress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port    = number
    to_port      = number
    protocol     = string
    source_sg_id = string
    description  = string
  }))
  default = []
}

variable "sg_ingress_rules_self" {
  description = "Ingress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    description = string
  }))
  default = []
}

variable "sg_egress_rules_cidr" {
  description = "Egress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = []
}

variable "sg_egress_rules_source_sg" {
  description = "Egress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port    = number
    to_port      = number
    protocol     = string
    source_sg_id = string
    description  = string
  }))
  default = []
}

variable "sg_egress_rules_self" {
  description = "Egress Rule(s) for the Security Group associated with the Application Load Balancer"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    description = string
  }))
  default = []
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the Security Group to be created and attached with the Load Balancer"
}

#WAF-ACL Vars

variable "waf_acl" {
  description = "Boolean to decide if WAF ACL association is needed for the Load Balancer or not"
  type        = bool
  default     = false
}

variable "waf_acl_name" {
  description = "WAF ACL Name to be associated with the Load Balancer"
  type        = string
  default     = ""
}

variable "waf_acl_scope" {
  description = "WAF ACL Scope, with possible values of REGIONAL or CLOUDFRONT"
  type        = string
  default     = ""
}

variable "waf_acl_region" {
  description = "WAF ACL Region needed only when WAF_ACL_SCOPE is set to `CLOUDFRONT`"
  type        = string
  default     = ""
}

#Load Balancer Vars

variable "create_alb" {
  description = "Controls if the Load Balancer should be created or not"
  type        = bool
  default     = true
}

variable "lb_logs" {
  description = "Map containing access logging configuration for load balancer."
  type        = map(string)
  default     = {}
}

variable "alb_name" {
  description = "Application Load Balancer name"
  type        = string
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
}

variable "ec2_subnets" {
  description = "Subnets to use for the Load Balancer"
  type        = list(any)
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
}

variable "xff_header_processing_mode" {
  description = "Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request before sending the request to the target. The possible values are append, preserve, and remove. Only valid for Load Balancers of type application"
  type        = string
  default     = "append"
}

variable "enable_waf_fail_open" {
  description = "Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF"
  type        = bool
  default     = false
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  type        = string
  default     = "defensive"
}

# Target Group Vars

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

# Listener Vars

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to http_tcp_listeners[count.index])"
  type        = any
  default     = []
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "acm_data_block" {
  description = "Boolean to decide whether ACM Data block is needed to fetch the ACM Cert ARN for HTTPS Listener"
  type        = bool
  default     = false
}

variable "acm_domain" {
  description = "Domain name required to fetch the appropriate ACM Certificate to be attached to the HTTPS Listener"
  type        = string
  default     = ""
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "dd_alerts_to" {
  description = "Where to send datadog alerts for this load balancer"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^@|^$", var.dd_alerts_to))
    error_message = "Datadog targets must begin with an @."
  }
}

variable "stage" {
  type        = string
  description = "Stage this resource belongs to (dev/prod/staging/sandbox)"
  default     = "sandbox"
  validation {
    condition     = contains(["prod", "prod-dr", "staging", "dev", "sandbox"], var.stage)
    error_message = "The valid values are: dev/prod/prod-dr/staging/sandbox."
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


