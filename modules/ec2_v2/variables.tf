variable "stage" {
  description = "Environment (Dev/Stg/Prd)"
  type        = string
}

variable "technology" {
  type = string
}

variable "ec2_count" {
  type    = string
  default = "1"
}
variable "create" {
  description = "Enable or disable creation of EC2 instances"
  type        = bool
  default     = true
}

variable "ec2_ami" {
  description = "AMI to Deploy"
  type        = string
}

variable "ec2_instance_type" {
  description = "Type of instance to launch"
  type        = string
}

variable "ec2_subnets" {
  description = "Subnets to use for this ASG"
  type        = string
  default     = null
}

variable "ec2_AZ" {
  description = "Availability Zone for this region"
  type        = string
  default     = null
}

variable "ec2_security_groups" {
  description = "Security Groups to associate with"
  type        = list(any)
}

variable "ec2_key_name" {
  type    = string
  default = ""
}

variable "ec2_aws_region" {
  type    = string
  default = "us-east-1"
}

variable "az" {
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}
variable "naming" {
  type = map(any)
  default = {
    "0" = "a"
    "1" = "b"
    "2" = "c"
    "3" = "d"
    "4" = "e"
    "5" = "f"
    "6" = "g"
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}