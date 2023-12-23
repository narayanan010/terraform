resource "aws_route_table" "privrt-us-east-1a" {
  provider         = aws
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "nat-0e5da6395f591ccaf"
  }

  route {
    cidr_block = "10.108.0.0/16"
    gateway_id = "vgw-0122a994092cfb8ab"
  }

  route {
    cidr_block                = "10.114.24.0/21"
    vpc_peering_connection_id = "pcx-0d3d882c2aed8e856"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-0679018695ad1045a"
  }

  tags = {
    Name                = "privrt-us-east-1a"
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
    Name                = "privrt-us-east-1a"
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

  vpc_id = "vpc-0de18ef8cf1d96a82"
}

resource "aws_route_table" "pubrt-us-east-1a" {
  provider                    = aws
  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = "igw-0498d63945c4b0b2f"
  }

  route {
    cidr_block                = "10.114.24.0/21"
    vpc_peering_connection_id = "pcx-0d3d882c2aed8e856"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-0679018695ad1045a"
  }

  tags = {
    Name                = "pubrt-us-east-1a"
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
    Name                = "pubrt-us-east-1a"
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

  vpc_id = "vpc-0de18ef8cf1d96a82"
}

resource "aws_route_table" "rtb-0c8cf5226517fcd82" {
  provider = aws
  vpc_id   = "vpc-0de18ef8cf1d96a82"
}

resource "aws_route_table" "pubrt-us-east-1b" {
  provider = aws
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0498d63945c4b0b2f"
  }

  route {
    cidr_block                = "10.114.24.0/21"
    vpc_peering_connection_id = "pcx-0d3d882c2aed8e856"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-0679018695ad1045a"
  }

  tags = {
    Name                = "pubrt-us-east-1b"
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
    Name                = "pubrt-us-east-1b"
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

  vpc_id = "vpc-0de18ef8cf1d96a82"
}

resource "aws_route_table" "privrt-us-east-1b" {
  provider         = aws
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "nat-0a3bafff85f0fbfdf"
  }

  route {
    cidr_block = "10.108.0.0/16"
    gateway_id = "vgw-0122a994092cfb8ab"
  }

  route {
    cidr_block                = "10.114.24.0/21"
    vpc_peering_connection_id = "pcx-0d3d882c2aed8e856"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-0679018695ad1045a"
  }

  tags = {
    Name                = "privrt-us-east-1b"
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
    Name                = "privrt-us-east-1b"
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

  vpc_id = "vpc-0de18ef8cf1d96a82"
}