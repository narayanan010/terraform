module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf"

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
  web_acl_name  = var.application
  web_acl_scope = var.web_acl_scope
  vertical      = var.vertical
  stage         = var.stage

  #Rules
  custom_path_size_checker_action_list = [
    { uri_path = "/fsrelay", uri_path_constraint = "CONTAINS", size = 0, size_comparison_operator = "GE", action = "allow", priority = 0 },
    { uri_path = "/partialreview", uri_path_constraint = "EXACTLY", size = 8192, size_comparison_operator = "GE", action = "allow", priority = 1 },
    { uri_path = "/review", uri_path_constraint = "EXACTLY", size = 8192, size_comparison_operator = "GE", action = "allow", priority = 2 },
    { uri_path = "/honeypot", uri_path_constraint = "EXACTLY", size = 8192, size_comparison_operator = "GE", action = "allow", priority = 3 }
  ]

  # Custom rule group
  custom_rule_group_list = [
    {rule_group_arn = aws_wafv2_rule_group.method_regex.arn, priority = 4}
  ]

  # Oversized requests
  oversized_body_requests_rule_status             = "block"
  oversized_body_requests_rule_priority           = 5
  oversized_headers_requests_rule_status          = "block"
  oversized_headers_requests_rule_priority        = 6
  oversized_cookies_requests_rule_status          = "block"
  oversized_cookies_requests_rule_priority        = 7

  # DENY LIST rule
  custom_deny_ip_list_status                      = "block"
  custom_deny_ip_list_rule_priority               = 8
  custom_deny_ip_list_address_version             = "IPV4"
  custom_deny_ip_list_addresses                   = ["194.163.144.246/32"]

  # AWS IP reputation list
  aws_managed_rules_ip_reputation_list_enabled    = true
  aws_managed_rules_ip_reputation_list_priority   = 9

  # AWS KNOWN BAD INPUTS rule set
  aws_managed_rules_known_bad_inputs_set_enabled  = true
  aws_managed_rules_known_bad_inputs_set_priority = 10

  # AWS CORE rule set
  aws_managed_rules_common_rule_set_enabled       = true
  aws_managed_rules_common_rule_set_priority      = 11

  # Nginix rule
  nginx_server_list_rule_priority                 = 12
  nginx_server_list_rule_status                   = "count"
  nginx_servers_ip_list_address_version           = "IPV4"
  nginx_servers_ip_list_addresses                 = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
                                                     "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32",
                                                     "34.234.249.188/32", "35.174.34.104/32", "34.207.38.254/32",
                                                     "52.39.77.81/32"]

  providers = {
    aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "crf"
  tag_app_component       = "waf"
  tag_function            = "security"
  tag_business_unit       = "gdm"
  tag_app_environment     = "staging"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "narayanan.narasimhan@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "staging"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "crf"
  tag_environment         = "staging"
}