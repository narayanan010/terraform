# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_ssm_parameter" "bidding-staging-ssm-redis-random-name" {
  allowed_pattern = null
  arn             = "arn:aws:ssm:us-east-1:176540105868:parameter/redis_random_name-bidding-staging"
  data_type       = "text"
  description     = null
  key_id          = "alias/aws/ssm"
  name            = "redis_random_name-bidding-staging"
  tags = {
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "ssm-param-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tags_all = {
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "ssm-param-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
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
