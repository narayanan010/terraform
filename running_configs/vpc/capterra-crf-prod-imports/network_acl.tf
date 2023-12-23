resource "aws_default_network_acl" "acl-02fb22ea6fb7e953d" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  egress {
    action          = "allow"
    from_port       = "0"
    icmp_code       = "0"
    icmp_type       = "0"
    ipv6_cidr_block = "::/0"
    protocol        = "-1"
    rule_no         = "101"
    to_port         = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action          = "allow"
    from_port       = "0"
    icmp_code       = "0"
    icmp_type       = "0"
    ipv6_cidr_block = "::/0"
    protocol        = "-1"
    rule_no         = "101"
    to_port         = "0"
  }

  subnet_ids             = ["subnet-09916c91f46cb9dcd", "subnet-0e32470cc3fffeb76"]
  default_network_acl_id = "acl-02fb22ea6fb7e953d"
}

resource "aws_network_acl" "acl-0953d9e63a9c58897" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "101"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "10.114.0.0/16"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = ["subnet-00530c7b77a3fe199", "subnet-03a522af72354073d", "subnet-0520d3d584b20a479"]
  vpc_id = "vpc-0de18ef8cf1d96a82"

  tags = {
    Name                = "PrivNACL-prod-us-east-1-capterra-crf"
    VPC                 = "prod-us-east-1-capterra-crf"
    VPC_ID              = "vpc-0de18ef8cf1d96a82"
    app_component       = "CRF"
    app_contacts        = "capterra-devops"
    app_environment     = "prod"
    application         = "capterra-crf"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "prod"
    function            = "capterra-reviews"
    monitoring          = "false"
    network_environment = "prod"
    product             = "CRF"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "Reviews"
  }

  tags_all = {
    Name                = "PrivNACL-prod-us-east-1-capterra-crf"
    VPC                 = "prod-us-east-1-capterra-crf"
    VPC_ID              = "vpc-0de18ef8cf1d96a82"
    app_component       = "CRF"
    app_contacts        = "capterra-devops"
    app_environment     = "prod"
    application         = "capterra-crf"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "prod"
    function            = "capterra-reviews"
    monitoring          = "false"
    network_environment = "prod"
    product             = "CRF"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "Reviews"
  }
}