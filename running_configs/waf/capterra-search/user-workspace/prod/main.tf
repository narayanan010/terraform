module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.0"

  #Logging
  waf_logging_enabled                 = true
  waf_logging_filter_enabled          = true
  waf_logging_filter_default_behavior = "DROP"
  waf_logging_filters = [
    { behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{ type = "action_condition", effect = "BLOCK" }] },
    { behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{ type = "action_condition", effect = "COUNT" }] },
    { behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{ type = "action_condition", effect = "CAPTCHA" }] }
  ]

  #Web ACL                
  web_acl_name  = "user-workspace"
  web_acl_scope = "REGIONAL"
  vertical      = "capterra"
  stage         = "prod"

  # Oversized requests
  oversized_body_requests_rule_status      = "block"
  oversized_body_requests_rule_priority    = 0
  oversized_headers_requests_rule_status   = "block"
  oversized_headers_requests_rule_priority = 1
  oversized_cookies_requests_rule_status   = "block"
  oversized_cookies_requests_rule_priority = 2

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled                               = true
  aws_managed_rules_ip_reputation_list_priority                              = 3
  aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded = true

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled                           = true
  aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded = true
  aws_managed_rules_common_rule_set_priority                          = 4

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled  = true
  aws_managed_rules_known_bad_inputs_set_priority = 5

  # AWS BOT Control rule set
  aws_managed_rules_bot_control_rule_set_enabled                            = true
  aws_managed_rules_bot_control_rule_set_priority                           = 6
  aws_managed_rules_bot_control_rule_set_CategoryAdvertising_excluded       = true
  aws_managed_rules_bot_control_rule_set_CategoryArchiver_excluded          = true
  aws_managed_rules_bot_control_rule_set_CategoryContentFetcher_excluded    = true
  aws_managed_rules_bot_control_rule_set_CategoryEmailClient_excluded       = true
  aws_managed_rules_bot_control_rule_set_CategoryHttpLibrary_excluded       = true
  aws_managed_rules_bot_control_rule_set_CategoryLinkChecker_excluded       = true
  aws_managed_rules_bot_control_rule_set_CategoryMiscellaneous_excluded     = true
  aws_managed_rules_bot_control_rule_set_CategoryMonitoring_excluded        = true
  aws_managed_rules_bot_control_rule_set_CategoryScrapingFramework_excluded = true
  aws_managed_rules_bot_control_rule_set_CategorySearchEngine_excluded      = true
  aws_managed_rules_bot_control_rule_set_CategorySecurity_excluded          = true
  aws_managed_rules_bot_control_rule_set_CategorySeo_excluded               = true
  aws_managed_rules_bot_control_rule_set_CategorySocialMedia_excluded       = true
  aws_managed_rules_bot_control_rule_set_SignalKnownBotDataCenter_excluded  = true
  aws_managed_rules_bot_control_rule_set_SignalNonBrowserUserAgent_excluded = true
  aws_managed_rules_bot_control_rule_set_SignalAutomatedBrowser_excluded    = true

  providers = {
    aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "user-workspace"
  tag_app_component       = "waf"
  tag_function            = "security"
  tag_business_unit       = "gdm"
  tag_app_environment     = "prod"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "narayanan.narasimhan@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "prod"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "user-workspace"
  tag_environment         = "prod"
}

resource "aws_wafv2_web_acl_association" "bx-ba-api" {
  provider = aws.primary

  resource_arn = data.terraform_remote_state.common_resources.outputs.alb_api_bluegreen_arn
  web_acl_arn  = module.aws_waf_module.web_acl_arn
}
