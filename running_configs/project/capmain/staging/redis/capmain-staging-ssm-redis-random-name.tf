# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_ssm_parameter" "capmain-staging-ssm-redis-random-name" {
  allowed_pattern = null
  arn             = "arn:aws:ssm:us-east-1:176540105868:parameter/redis_random_name-capmain-staging-redis"
  data_type       = "text"
  description     = null
  key_id          = "alias/aws/ssm"
  name            = "redis_random_name-capmain-staging-redis"
  tags = {
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "ssm-param-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "capmain"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tags_all = {
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "ssm-param-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "capmain"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tier  = "Standard"
  type  = "SecureString"
  value = "changeme" # sensitive
  lifecycle {
    ignore_changes = [value]
  }
}
