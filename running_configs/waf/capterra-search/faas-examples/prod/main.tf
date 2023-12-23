module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.0"

  #Logging
  waf_logging_enabled                                                              = true
  waf_logging_filter_enabled                                                       = true
  waf_logging_filter_default_behavior                                              = "DROP"
  waf_logging_filters                                                              = [
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "BLOCK"}]},
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "COUNT"}]},
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "CAPTCHA"}]}
  ]

  #Web ACL                
  web_acl_name                                                                     = "faasexamples"
  web_acl_scope                                                                    = "CLOUDFRONT"
  vertical                                                                         = "capterra"
  stage                                                                            = "prod"
  custom_app_name                                                                  = "dd-synthetics"

  # Oversized requests
  oversized_body_requests_rule_status                                             = "block"
  oversized_body_requests_rule_priority                                           = 0
  oversized_headers_requests_rule_status                                          = "block"
  oversized_headers_requests_rule_priority                                        = 1
  oversized_cookies_requests_rule_status                                          = "block"
  oversized_cookies_requests_rule_priority                                        = 2

  # Allow LIST rule
  custom_allow_ip_list_status                                                      = "allow"
  custom_allow_ip_list_rule_priority                                               = 3
  custom_allow_ip_list_address_version                                             = "IPV4"
  custom_allow_ip_list_addresses                                                   = []

  # ALLOW LIST for dd-synthetics
  custom_allow_app_ip_list_status                                                 = "allow"
  custom_allow_app_ip_list_rule_priority                                          = 4
  custom_allow_app_ip_list_statement                                              = true
  custom_allow_app_ip_list_address_version                                        = "IPV4"
  custom_allow_app_ip_list_addresses                                              = ["107.21.25.247/32", "3.92.150.182/32", "52.55.56.26/32",
                                                                                    "3.18.188.104/32", "3.18.197.0/32", "3.18.172.189/32",
                                                                                    "52.35.61.232/32", "34.208.32.189/32", "52.89.221.151/32"]

  # Nginix rule
  nginx_server_list_rule_priority                                                 = 5
  nginx_server_list_rule_status                                                   = "block"
  nginx_servers_ip_list_address_version                                           = "IPV4"
  nginx_servers_ip_list_addresses                                                 = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
                                                                                    "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32", 
                                                                                    "34.234.249.188/32","35.174.34.104/32", "34.207.38.254/32", 
                                                                                    "52.39.77.81/32","54.156.208.110/32","52.87.180.57/32"]

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled                                  = true
  aws_managed_rules_known_bad_inputs_set_priority                                 = 6

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled                                    = true
  aws_managed_rules_ip_reputation_list_priority                                   = 7
  aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded      = true

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled                                       = true
  aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded             = true
  aws_managed_rules_common_rule_set_priority                                      = 8

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "faasexamples"
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
  tag_product             = "faasexamples"
  tag_environment         = "prod"
}