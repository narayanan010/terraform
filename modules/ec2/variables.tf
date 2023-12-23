variable  "stage" {
description   =    "Environment (Dev/Stg/Prd)"
type          =    "string"
}

variable  "platform"  {
description   =   "Application Name"
type          =   "string"
}

variable "vertical" {
type = "string"
}

variable "technology" {
    type = "string"
}

variable ec2_count {
type = "string"
default = "1"

}

variable ec2_ami {
    description = "AMI to Deploy"
    type = "string"    
}

variable ec2_instance_type {
    description = "Type of instance to launch"
    type = "string"
}

variable ec2_subnets {
    description = "Subnets to use for this ASG"
    type = "list"    
}

variable ec2_security_groups {
    description = "Security Groups to associate with"
    type = "list"
}

variable ec2_key_name {
    type = "string"
    default = "prod-us-east-1-capterra-general-purpose-key"

}

variable ec2_aws_region {
    type = "string"
    default = "us-east-1"
}

variable az {
    default = [
        "us-east-1a",
        "us-east-1b"
    ]
}

variable naming {
    type = "map"
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