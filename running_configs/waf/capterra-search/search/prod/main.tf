module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.2"

  #Logging
  waf_logging_enabled = true
  waf_logging_filter_enabled = true
  waf_logging_filter_default_behavior = "DROP"
  waf_logging_filters = [
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "BLOCK"}]},
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "COUNT"}]},
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "CAPTCHA"}]}
  ]

  #Web ACL                
  web_acl_name  = "search"
  web_acl_scope = "CLOUDFRONT"
  vertical      = "capterra"
  stage         = "prod"

  # Oversized requests
  oversized_body_requests_rule_status                                             = "block"
  oversized_body_requests_rule_priority                                           = 0
  oversized_headers_requests_rule_status                                          = "block"
  oversized_headers_requests_rule_priority                                        = 1
  oversized_cookies_requests_rule_status                                          = "block"
  oversized_cookies_requests_rule_priority                                        = 2

  # Custom rule group
  custom_rule_group_list = [
    {rule_group_arn = aws_wafv2_rule_group.nginx-rate-limit.arn, priority = 3}
  ]

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled                                    = true
  aws_managed_rules_ip_reputation_list_priority                                   = 4
  aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded      = true

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled                                  = true
  aws_managed_rules_known_bad_inputs_set_priority                                 = 5

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled                                       = true
  aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded             = true
  aws_managed_rules_common_rule_set_priority                                      = 6
  aws_managed_rules_common_rule_set_CrossSiteScripting_BODY_excluded              = true
  aws_managed_rules_common_rule_set_CrossSiteScripting_COOKIE_excluded            = true

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "search"
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
  tag_product             = "search"
  tag_environment         = "prod"
}