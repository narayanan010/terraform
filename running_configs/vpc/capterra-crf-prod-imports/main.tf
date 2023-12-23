resource "aws_vpc" "vpc-0de18ef8cf1d96a82" {
  provider                             = aws
  assign_generated_ipv6_cidr_block     = "true"
  cidr_block                           = "10.114.88.0/21"
  enable_dns_hostnames                 = "true"
  enable_dns_support                   = "true"
  instance_tenancy                     = "default"
  ipv6_cidr_block_network_border_group = "us-east-1"

  tags = {
    Name                = "prod-us-east-1-capterra-crf"
    app_component       = "CRF"
    app_contacts        = "capterra-devops"
    app_environment     = "prod"
    application         = "capterra-crf"
    business_unit       = "GDM"
    cidr                = "10.114.88.0/21"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "prod"
    function            = "capterra-reviews"
    monitoring          = "false"
    network_environment = "prod"
    product             = "CRF"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "prod-us-east-1-capterra-crf"
    app_component       = "CRF"
    app_contacts        = "capterra-devops"
    app_environment     = "prod"
    application         = "capterra-crf"
    business_unit       = "GDM"
    cidr                = "10.114.88.0/21"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "prod"
    function            = "capterra-reviews"
    monitoring          = "false"
    network_environment = "prod"
    product             = "CRF"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra-dr"
  }
}