variable ec2_key_name {
    type = "string"
    default = "prod-us-west-2-capterra-general-purpose-key"

}

variable ec2_aws_region {
    type = "string"
    default = "us-west-2"
}

variable az {
    default = [
        "us-west-2a",
        "us-west-2b",
        "us-west-2c"
    ]
}