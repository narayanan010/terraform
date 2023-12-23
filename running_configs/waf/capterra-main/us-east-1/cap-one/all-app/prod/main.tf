module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.0"

  #Logging
  waf_logging_enabled                                                              = false
  waf_logging_filter_enabled                                                       = false


  #Web ACL                
  web_acl_name                                                                     = "all-capone"
  web_acl_scope                                                                    = "REGIONAL"
  vertical                                                                         = "capterra"
  stage                                                                            = "prod"

  # Oversized requests
  oversized_body_requests_rule_status                                              = "block"
  oversized_body_requests_rule_priority                                            = 0
  oversized_headers_requests_rule_status                                           = "block"
  oversized_headers_requests_rule_priority                                         = 1
  oversized_cookies_requests_rule_status                                           = "block"
  oversized_cookies_requests_rule_priority                                         = 2

  # Nginix rule
  nginx_server_list_rule_priority                                                  = 3
  nginx_server_list_rule_status                                                    = "block"
  nginx_servers_ip_list_address_version                                            = "IPV4"
  nginx_servers_ip_list_addresses                                                  = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
                                                                                      "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32", 
                                                                                      "34.234.249.188/32", "35.174.34.104/32", "34.207.38.254/32", 
                                                                                      "52.39.77.81/32", "3.214.68.166/32", "52.206.39.209/32",
                                                                                      "23.22.58.212/32", "35.175.4.28/32"]

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled                                   = true
  aws_managed_rules_known_bad_inputs_set_priority                                  = 4

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled                                     = true
  aws_managed_rules_ip_reputation_list_priority                                    = 5
  aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded       = true

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled                                        = true
  aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded              = true
  aws_managed_rules_common_rule_set_priority                                       = 6

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = var.tag_application
  tag_app_component       = var.tag_app_component
  tag_function            = var.tag_function
  tag_business_unit       = var.tag_business_unit
  tag_app_environment     = var.tag_app_environment
  tag_app_contacts        = var.tag_app_contacts
  tag_created_by          = var.tag_created_by
  tag_system_risk_class   = var.tag_system_risk_class
  tag_region              = var.tag_region
  tag_network_environment = var.tag_network_environment
  tag_monitoring          = var.tag_monitoring
  tag_terraform_managed   = var.tag_terraform_managed
  tag_vertical            = var.tag_vertical
  tag_product             = var.tag_product
  tag_environment         = var.tag_environment
}