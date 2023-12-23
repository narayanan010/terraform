module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.0"

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
  web_acl_name  = "glossary-ui"
  web_acl_scope = "CLOUDFRONT"
  vertical      = "capterra"
  stage         = "prod"


  # Oversized requests
  oversized_body_requests_rule_status                                              = "block"
  oversized_body_requests_rule_priority                                            = 0
  oversized_headers_requests_rule_status                                           = "block"
  oversized_headers_requests_rule_priority                                         = 1
  oversized_cookies_requests_rule_status                                           = "block"
  oversized_cookies_requests_rule_priority                                         = 2

  # Nginix rule
  nginx_server_list_rule_priority                                                 = 3
  nginx_server_list_rule_status                                                   = "count"
  nginx_servers_ip_list_address_version                                           = "IPV4"
  nginx_servers_ip_list_addresses                                                 = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
                                                                                    "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32", 
                                                                                    "34.234.249.188/32","35.174.34.104/32", "34.207.38.254/32", 
                                                                                    "52.39.77.81/32"]

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled                                  = true
  aws_managed_rules_known_bad_inputs_set_priority                                 = 4

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled                                    = true
  aws_managed_rules_ip_reputation_list_priority                                   = 5
  aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded      = true

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled                                       = true
  aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded             = true
  aws_managed_rules_common_rule_set_priority                                      = 6

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "glossary-ui"
  tag_app_component       = "waf"
  tag_function            = "security"
  tag_business_unit       = "gdm"
  tag_app_environment     = "prod"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "yajush.garg@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "prod"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "glossary-ui"
  tag_environment         = "prod"
}