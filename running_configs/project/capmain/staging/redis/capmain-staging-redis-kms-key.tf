# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "a4b8d5bd-e03d-484c-900e-d93c63374ab4"
resource "aws_kms_key" "capmain-staging-redis-kms-key" {
  bypass_policy_lockout_safety_check = null
  custom_key_store_id                = null
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  deletion_window_in_days            = null
  description                        = "This key is used in encryption at rest for Elasticache Redis Cluster capmain-staging-redis"
  enable_key_rotation                = false
  is_enabled                         = true
  key_usage                          = "ENCRYPT_DECRYPT"
  multi_region                       = false
  policy                             = "{\"Id\":\"key-default-1\",\"Statement\":[{\"Action\":\"kms:*\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::176540105868:root\"},\"Resource\":\"*\",\"Sid\":\"Enable IAM User Permissions\"}],\"Version\":\"2012-10-17\"}"
  tags = {
    CreatorAutoTag      = "1622714443894695000"
    CreatorId           = "AROASSGU4HSGA57LGJJFL"
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "cmk"
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
    app_component       = "redis"
    app_contacts        = "capterra-devops@gartner.com"
    app_environment     = "staging"
    application         = "capmain"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "cmk"
    monitoring          = "no"
    network_environment = "staging"
    product             = "capmain"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
}
