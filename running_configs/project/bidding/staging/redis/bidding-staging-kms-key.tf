# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "fb078e93-bf93-4bc4-b7fe-f991f2fe4496"
resource "aws_kms_key" "bidding-staging-kms-key" {
  bypass_policy_lockout_safety_check = null
  custom_key_store_id                = null
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  deletion_window_in_days            = null
  description                        = "This key is used in encryption at rest for Elasticache Redis Cluster bidding-staging"
  enable_key_rotation                = false
  is_enabled                         = true
  key_usage                          = "ENCRYPT_DECRYPT"
  multi_region                       = false
  policy                             = "{\"Id\":\"key-default-1\",\"Statement\":[{\"Action\":\"kms:*\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::176540105868:root\"},\"Resource\":\"*\",\"Sid\":\"Enable IAM User Permissions\"}],\"Version\":\"2012-10-17\"}"
  tags = {
    CreatorAutoTag      = "1619696787275451000"
    CreatorId           = "AROASSGU4HSGA57LGJJFL"
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "cmk"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tags_all = {
    CreatorAutoTag      = "1619696787275451000"
    CreatorId           = "AROASSGU4HSGA57LGJJFL"
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "cmk"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
}
