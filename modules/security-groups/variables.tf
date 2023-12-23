# Security Group Vars

variable "sec_grp_names" {
  description = "Names of Security Groups to be created"
  type = list(object({
   name        = string
   vpc_id      = string
   description = string
  }))
  default = []
}

variable "create_sg" {
  description = "Boolean to check if Security Groups are to be created"
  type        = bool
  default     = false
}

variable "create_sg_ingress_cidr" {
  description = "Boolean to check if Security Group Ingress CIDR rules are to be created"
  type        = bool
  default     = false
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
  default     = false
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

variable "sg_ingress_rules_cidr" {
  description = "Ingress Rule(s) for the Security Group"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default     = []
}

variable "sg_ingress_rules_source_sg" {
  description = "Ingress Rule(s) for the Security Group"
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
  description = "Ingress Rule(s) for the Security Group"
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
  description = "Egress Rule(s) for the Security Group"
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
  description = "Egress Rule(s) for the Security Group"
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
  description = "Egress Rule(s) for the Security Group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    description = string
  }))
  default = []
}

/*variable "vpc_id" {
  type        = string
  description = "VPC ID for the Security Group to be created"
}*/