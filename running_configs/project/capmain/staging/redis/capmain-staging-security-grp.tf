# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-0a8c443cc6d3da30c"
resource "aws_security_group" "capmain_redis_sg" {
  description = "Managed by Terraform"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all egress traffic"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["10.114.24.128/32"]
    description      = "cd1a"
    from_port        = 6379
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 6379
    }, {
    cidr_blocks      = ["10.114.32.0/21"]
    description      = "Allow inbound traffic from CIDR blocks"
    from_port        = 6379
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 6379
    }, {
    cidr_blocks      = []
    description      = "Prefix List to allow secondary private range from staging eks"
    from_port        = 6379
    ipv6_cidr_blocks = []
    prefix_list_ids  = ["pl-09e58e0bd3c8445a6"]
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 6379
  }]
  name                   = "tf-sg-capmain-staging-redis"
  name_prefix            = null
  revoke_rules_on_delete = null
  tags = {
    CreatorAutoTag      = "1622714443894695000"
    CreatorId           = "AROASSGU4HSGA57LGJJFL"
    Name                = "tf-sg-capmain-staging-redis"
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    monitoring          = "no"
    network_environment = "staging"
    product             = "capmain"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tags_all = {
    CreatorAutoTag      = "1622714443894695000"
    CreatorId           = "AROASSGU4HSGA57LGJJFL"
    Name                = "tf-sg-capmain-staging-redis"
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    monitoring          = "no"
    network_environment = "staging"
    product             = "capmain"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  vpc_id = "vpc-60714d06"
}
