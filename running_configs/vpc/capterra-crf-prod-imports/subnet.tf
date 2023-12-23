resource "aws_subnet" "priv-subnet-us-east-1b" {
  provider                                       = aws
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.89.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name                = "priv-subnet-us-east-1b"
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
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "priv-subnet-us-east-1b"
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
    vertical            = "capterra-dr"
  }

  vpc_id = aws_vpc.vpc-0de18ef8cf1d96a82.id
}

resource "aws_subnet" "priv-subnet-us-east-1a" {
  provider                                       = aws
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.88.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name                = "priv-subnet-us-east-1a"
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
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "priv-subnet-us-east-1a"
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
    vertical            = "capterra-dr"
  }

  vpc_id = aws_vpc.vpc-0de18ef8cf1d96a82.id
}

resource "aws_subnet" "priv-subnet-us-east-1c" {
  provider                                       = aws
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.92.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name                = "priv-subnet-us-east-1c"
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
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "priv-subnet-us-east-1c"
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
    vertical            = "capterra-dr"
  }

  vpc_id = aws_vpc.vpc-0de18ef8cf1d96a82.id
}

resource "aws_subnet" "pub-subnet-us-east-1a" {
  provider                                       = aws
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.94.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "true"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name                = "pub-subnet-us-east-1a"
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
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "pub-subnet-us-east-1a"
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
    vertical            = "capterra-dr"
  }

  vpc_id = aws_vpc.vpc-0de18ef8cf1d96a82.id
}

resource "aws_subnet" "pub-subnet-us-east-1b" {
  provider                                       = aws
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.95.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "true"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name                = "pub-subnet-us-east-1b"
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
    vertical            = "capterra-dr"
  }

  tags_all = {
    Name                = "pub-subnet-us-east-1b"
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
    vertical            = "capterra-dr"
  }

  vpc_id = aws_vpc.vpc-0de18ef8cf1d96a82.id
}