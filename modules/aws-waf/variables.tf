### GENERAL ###

variable "web_acl_name" {
  type        = string
  description = "Name of the Web ACL which needs to be created."
}

variable "web_acl_scope" {
  type        = string
  default     = "CLOUDFRONT"
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider."
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.web_acl_scope)
    error_message = "The valid values are: CLOUDFRONT, REGIONAL."
  }
}

variable "stage" {
  type        = string
  description = "Stage this resource belongs to (dev/prod/staging/sandbox)"
  default     = "sandbox"
  validation {
    condition     = contains(["prod", "prod-dr", "staging", "dev", "sandbox"], var.stage)
    error_message = "The valid values are: dev/prod/staging/sandbox."
  }
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  default     = "capterra"
  validation {
    condition     = contains(["capterra", "getapp", "softwareadvice"], var.vertical)
    error_message = "The valid values are: capterra/getapp/softwareadvice."
  }
}

##Tags

#tags. These values can be overwritten when calling module.
variable "tag_application" {
  type    = string
  default = ""
}
variable "tag_app_component" {
  type    = string
  default = ""
}
variable "tag_function" {
  type    = string
  default = ""
}
variable "tag_business_unit" {
  type    = string
  default = ""
}
variable "tag_app_environment" {
  type    = string
  default = ""
}
variable "tag_app_contacts" {
  type    = string
  default = "opsteam@capterra.com"
}
variable "tag_created_by" {
  type    = string
  default = "fabio.perrone@gartner.com"
}

variable "waf_dd_alerts_to" {
  type    = string
  default = ""
  validation {
    condition     = can(regex("^@|^$", var.waf_dd_alerts_to))
    error_message = "Datadog targets must begin with an @."
  }
}

variable "tag_system_risk_class" {
  type    = string
  default = "3"
}
variable "tag_region" {
  type    = string
  default = ""
}
variable "tag_network_environment" {
  type    = string
  default = ""
}
variable "tag_monitoring" {
  type    = string
  default = ""
}
variable "tag_terraform_managed" {
  type    = string
  default = "true"
}
variable "tag_vertical" {
  type    = string
  default = ""
}
variable "tag_product" {
  type    = string
  default = ""
}
variable "tag_environment" {
  type    = string
  default = ""
}

### LOGGING ###
variable "waf_logging_enabled" {
  type        = bool
  description = "Define if the logging has to be enabled or not for the WAF"
  default     = false
}

variable "waf_logging_destination" {
  type        = string
  description = "Define the destination of the logs. If not specified, but waf_logging_enabled is true, then a new Cloudwatch log group is created"
  default     = ""
}

variable "waf_logging_retention" {
  type        = number
  description = "Define the logs retention in days"
  default     = 0
}

variable "waf_logging_kms_key" {
  type        = string
  description = "Define the key to be used for logs encryption (the Key will need the right permissions first). If not specified the logs will not be encrypted"
  default     = ""
}

variable "waf_logging_redacted_field_single_header" {
  type        = bool
  description = "Define if it is needed to redact a single header in the logs"
  default     = false
}

variable "waf_logging_redacted_field_single_header_name" {
  type        = string
  description = "Define the name of the single header to be redacted in the logs"
  default     = "user-agent"
}

variable "waf_logging_redacted_field_method" {
  type        = bool
  description = "Define if it is needed to redact the method in the logs"
  default     = false
}

variable "waf_logging_redacted_field_query_string" {
  type        = bool
  description = "Define if it is needed to redact the query string in the logs"
  default     = false
}

variable "waf_logging_redacted_field_uri_path" {
  type        = bool
  description = "Define if it is needed to redact the request URI path in the logs"
  default     = false
}

variable "waf_logging_filter_enabled" {
  type        = bool
  description = "Define if WAF logs filter is enabled"
  default     = false
}

variable "waf_logging_filter_default_behavior" {
  type        = string
  description = "Define the default behavior of the log filter"
  default     = "KEEP"
  validation {
    condition     = contains(["KEEP", "DROP"], var.waf_logging_filter_default_behavior)
    error_message = "The valid values are: KEEP, DROP."
  }
}

variable "waf_logging_filters" {
  type = list(object({
    behavior    = string
    requirement = string
    conditions = list(object({
      type   = string
      effect = string
    }))
  }))
  description = "Define the logging filter behaviour and the conditions required in each filter."
  default     = []
}

#################### CUSTOM RULES ####################

###DENY LIST RULE ###
variable "custom_deny_ip_list_status" {
  type        = string
  description = "Define if the rule deny-ip-list is enabled and the working mode. The valid values are: disabled, count, block."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block"], var.custom_deny_ip_list_status)
    error_message = "The valid values are: disabled, count, block."
  }
}

variable "custom_deny_ip_list_rule_priority" {
  type        = number
  description = "Define the priority for deny-ip-list rule."
  default     = 10
}

variable "custom_deny_ip_list_address_version" {
  type        = string
  description = "Version of the IP Address version, ex. IPV4 or IPV6"
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "IPV6"], var.custom_deny_ip_list_address_version)
    error_message = "The valid values are: IPV4, IPV6."
  }
}

variable "custom_deny_ip_list_addresses" {
  type        = list(string)
  description = "Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list"
  default     = []
}

### ALLOW LIST RULE ###
variable "custom_allow_ip_list_status" {
  type        = string
  description = "Define if the rule allow-ip-list is enabled and the working mode. The valid values are: disabled, count, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "allow"], var.custom_allow_ip_list_status)
    error_message = "The valid values are: disabled, count, allow."
  }
}

variable "custom_allow_ip_list_rule_priority" {
  type        = number
  description = "Define the priority for allow-ip-list rule."
  default     = 10
}

variable "custom_allow_ip_list_address_version" {
  type        = string
  description = "Version of the IP Address version, ex. IPV4 or IPV6"
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "IPV6"], var.custom_allow_ip_list_address_version)
    error_message = "The valid values are: IPV4, IPV6."
  }
}

variable "custom_allow_ip_list_addresses" {
  type        = list(string)
  description = "Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list"
  default     = []
}

### ALLOW CUSTOM APP LIST RULE ###
variable "custom_app_name" {
  type        = string
  description = "Define application name for which custom allow rules are to be created"
  default     = ""
}

variable "custom_allow_app_ip_list_status" {
  type        = string
  description = "Define if the rule allow-ip-list is enabled and the working mode. The valid values are: disabled, count, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "allow"], var.custom_allow_app_ip_list_status)
    error_message = "The valid values are: disabled, count, allow."
  }
}

variable "custom_allow_app_ip_list_and_statement" {
  type        = bool
  description = "Define if the rule allow-app-ip-list-and-statement is enabled. Allows multiple statement conditions as part of the WAF rule."
  default     = false
}

variable "custom_allow_app_ip_list_positional_constraint" {
  type        = string
  description = "Define the constraint for the URI_PATH under byte_match_statement condition"
  default     = ""
}

variable "custom_allow_app_ip_list_search_string" {
  type        = string
  description = "Define the search string to be matched for URI_PATH under byte_match_statement condition"
  default     = ""
}

variable "custom_allow_app_ip_list_rule_priority" {
  type        = number
  description = "Define the priority for allow-ip-list rule."
  default     = 10
}

variable "custom_allow_app_ip_list_address_version" {
  type        = string
  description = "Version of the IP Address version, ex. IPV4 or IPV6"
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "IPV6"], var.custom_allow_app_ip_list_address_version)
    error_message = "The valid values are: IPV4, IPV6."
  }
}

variable "custom_allow_app_ip_list_addresses" {
  type        = list(string)
  description = "Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list"
  default     = []
}

### CHECK OVERSIZED REQUESTS ###
variable "oversized_body_requests_rule_status" {
  type        = string
  description = "Define if oversized BODY requests should be checked. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.oversized_body_requests_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "oversized_body_requests_rule_priority" {
  type        = number
  description = "Define the priority for oversized BODY requests rule."
  default     = 0
}

variable "oversized_headers_requests_rule_status" {
  type        = string
  description = "Define if oversized HEADERS requests should be checked. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.oversized_headers_requests_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "oversized_headers_requests_rule_priority" {
  type        = number
  description = "Define the priority for oversized HEADERS requests rule."
  default     = 1
}

variable "oversized_cookies_requests_rule_status" {
  type        = string
  description = "Define if oversized COOKIES requests should be checked. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.oversized_cookies_requests_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "oversized_cookies_requests_rule_priority" {
  type        = number
  description = "Define the priority for oversized COOKIES requests rule."
  default     = 2
}

### PATH SIZE ACTION LIST RULE ###
variable "custom_path_size_checker_action_list" {
  type = list(object({
    uri_path                 = string
    uri_path_constraint      = string
    size                     = number
    size_comparison_operator = string
    action                   = string
    priority                 = number
  }))
  description = "The variable is a list of object that must have uri_path, uri_path_constraint, size, size_comparison_operator, action, priority. Adding an object will result in a rule creation in which for a specific path and size the rule allows, block or count. Value of uri_path_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD; Value of size_comparison_operator must be one of: EQ, NE, LE, LT, GE, or GT. Value of action must be one of: count, block, allow. The path provided must start with / ."
  validation {
    condition = (
      alltrue([for rule in var.custom_path_size_checker_action_list : (
        contains(["EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"], rule.uri_path_constraint)
        && contains(["EQ", "NE", "LE", "LT", "GE", "GT"], rule.size_comparison_operator)
        && contains(["count", "block", "allow"], rule.action)
        && can(regex("\\/.*", rule.uri_path))
      )])
    )
    error_message = "Validation of an object failed. Value of uri_path_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD; Value of size_comparison_operator must be one of: EQ, NE, LE, LT, GE, or GT. Value of action must be one of: count, block, allow. The path provided must start with / ."
  }
  default = []
}

variable "custom_path_size_checker_action_list_rule_priority" {
  type        = number
  description = "Define the priority for path-size-action rule."
  default     = 10
}

### PATH CHECK ACTION LIST RULE ###
variable "custom_path_checker_action_list" {
  type = list(object({
    uri_path            = string
    uri_path_constraint = string
    action              = string
    priority            = number
  }))
  description = "The variable is a list of object that must have uri_path, uri_path_constraint, action, priority. Adding an object will result in a rule creation in which for a specific path the rule allows, block or count. Value of uri_path_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD; Value of size_comparison_operator must be one of: EQ, NE, LE, LT, GE, or GT. Value of action must be one of: count, block, allow. The path provided must start with / ."
  validation {
    condition = (
      alltrue([for rule in var.custom_path_checker_action_list : (
        contains(["EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"], rule.uri_path_constraint)
        && contains(["count", "block", "allow"], rule.action)
        # && can(regex("\\/.*", rule.uri_path))
      )])
    )
    error_message = "Validation of an object failed. Value of uri_path_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD; Value of action must be one of: count, block, allow. The path provided must start with / ."
  }
  default = []
}

variable "custom_path_checker_action_list_rule_priority" {
  type        = number
  description = "Define the priority for path-size-action rule."
  default     = 40
}


### NGINX SERVER LIST RULE ###
variable "nginx_server_list_rule_status" {
  type        = string
  description = "Define if the rule nginx-server-list is enabled and the working mode. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.nginx_server_list_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "nginx_server_list_rule_priority" {
  type        = number
  description = "Define the priority for nginx-server-list rule."
  default     = 10
}

variable "nginx_servers_ip_list_address_version" {
  type        = string
  description = "Version of the IP Address version, ex. IPV4 or IPV6"
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "IPV6"], var.nginx_servers_ip_list_address_version)
    error_message = "The valid values are: IPV4, IPV6."
  }
}

variable "nginx_servers_ip_list_addresses" {
  type        = list(string)
  description = "Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list"
  default     = []
}

### CLOUDFRONT EMPTY USER AGENT RULE ###
variable "cloudfront_empty_user_agent_rule_status" {
  type        = string
  description = "Define if the rule cloudfront-empty-user-agent is enabled and the working mode. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.cloudfront_empty_user_agent_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "cloudfront_empty_user_agent_rule_priority" {
  type        = number
  description = "Define the priority for cloudfront-empty-user-agent rule."
  default     = 20
}

### RATE LIMIT RULE ###
variable "rate_limit_rule_status" {
  type        = string
  description = "Define if the rule rate-limit is enabled and the working mode. The valid values are: disabled, count, block, allow."
  default     = "disabled"
  validation {
    condition     = contains(["disabled", "count", "block", "allow"], var.rate_limit_rule_status)
    error_message = "The valid values are: disabled, count, block, allow."
  }
}

variable "rate_limit_rule_value" {
  type        = number
  description = "Define the limit value for rule rate-limit"
  default     = 100
}

variable "rate_limit_rule_aggregate_key_type" {
  type        = string
  description = "Define the value for aggregate_key_type for rule rate-limit"
  default     = "IP"
}

variable "rate_limit_rule_forwarded_ip_header_name" {
  type        = string
  description = "Define the name of the header for rule rate-limit. Used only if aggregate_key_type is FORWARDED_IP."
  default     = "X-Real-IP"
}

variable "rate_limit_rule_forwarded_ip_fallback_behaviour" {
  type        = string
  description = "Define the value fallback behaviour for rule rate-limit. Used only if aggregate_key_type is FORWARDED_IP."
  default     = "MATCH"
}

variable "rate_limit_rule_priority" {
  type        = number
  description = "Define the priority for rate-limit rule."
  default     = 20
}

### CUSTOM RULE GROUP ###
variable "custom_rule_group_list" {
  type = list(object({
    rule_group_arn      = string
    priority            = number
  }))
  description = "The variable is a list of object that must have rule_group_arn, priority. Adding an object will result in a rule creation that use the injected rule group arn."
  default = []
}

#################### AWS MANAGED RULES ####################

#################### COMMON RULE SET ####################
variable "aws_managed_rules_common_rule_set_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesCommonRuleSet rule is enabled."
  default     = false
}

variable "aws_managed_rules_common_rule_set_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesCommonRuleSet rule set."
  default     = 90
}

variable "aws_managed_rules_common_rule_set_CrossSiteScripting_BODY_excluded" {
  type        = bool
  description = "Define if CrossSiteScripting_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_CrossSiteScripting_COOKIE_excluded" {
  type        = bool
  description = "Define if CrossSiteScripting_COOKIE rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_CrossSiteScripting_QUERYARGUMENTS_excluded" {
  type        = bool
  description = "Define if CrossSiteScripting_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_CrossSiteScripting_URIPATH_excluded" {
  type        = bool
  description = "Define if CrossSiteScripting_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_EC2MetaDataSSRF_BODY_excluded" {
  type        = bool
  description = "Define if EC2MetaDataSSRF_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_EC2MetaDataSSRF_COOKIE_excluded" {
  type        = bool
  description = "Define if EC2MetaDataSSRF_COOKIE rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_EC2MetaDataSSRF_QUERYARGUMENTS_excluded" {
  type        = bool
  description = "Define if EC2MetaDataSSRF_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_EC2MetaDataSSRF_URIPATH_excluded" {
  type        = bool
  description = "Define if EC2MetaDataSSRF_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericLFI_BODY_excluded" {
  type        = bool
  description = "Define if GenericLFI_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericLFI_QUERYARGUMENTS_excluded" {
  type        = bool
  description = "Define if GenericLFI_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericLFI_URIPATH_excluded" {
  type        = bool
  description = "Define if GenericLFI_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericRFI_BODY_excluded" {
  type        = bool
  description = "Define if GenericRFI_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericRFI_QUERYARGUMENTS_excluded" {
  type        = bool
  description = "Define if GenericRFI_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_GenericRFI_URIPATH_excluded" {
  type        = bool
  description = "Define if GenericRFI_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_NoUserAgent_HEADER_excluded" {
  type        = bool
  description = "Define if NoUserAgent_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_RestrictedExtensions_URIPATH_excluded" {
  type        = bool
  description = "Define if RestrictedExtensions_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_RestrictedExtensions_QUERYARGUMENTS_excluded" {
  type        = bool
  description = "Define if RestrictedExtensions_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_SizeRestrictions_BODY_excluded" {
  type        = bool
  description = "Define if SizeRestrictions_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_SizeRestrictions_Cookie_HEADER_excluded" {
  type        = bool
  description = "Define if SizeRestrictions_Cookie_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_SizeRestrictions_QUERYSTRING_excluded" {
  type        = bool
  description = "Define if SizeRestrictions_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_SizeRestrictions_URIPATH_excluded" {
  type        = bool
  description = "Define if SizeRestrictions_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}
variable "aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded" {
  type        = bool
  description = "Define if UserAgent_BadBots_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set."
  default     = false
}

#################### KNOWN BAD INPUTS RULE SET ####################
variable "aws_managed_rules_known_bad_inputs_set_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesKnownBadInputsRuleSet rule is enabled."
  default     = false
}

variable "aws_managed_rules_known_bad_inputs_set_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesKnownBadInputsRuleSet rule. This is AWS managed rule."
  default     = 100
}

variable "aws_managed_rules_known_ad_inputs_set_ExploitablePaths_URIPATH_excluded" {
  type        = bool
  description = "Define if ExploitablePaths_URIPATH rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}
variable "aws_managed_rules_known_ad_inputs_set_Host_localhost_HEADER_excluded" {
  type        = bool
  description = "Define if Host_localhost_HEADER rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}
variable "aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_BODY_excluded" {
  type        = bool
  description = "Define if JavaDeserializationRCE_BODY rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}
variable "aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_HEADER_excluded" {
  type        = bool
  description = "Define if JavaDeserializationRCE_HEADER rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}
variable "aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_QUERYSTRING_excluded" {
  type        = bool
  description = "Define if JavaDeserializationRCE_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}
variable "aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_URIPATH_excluded" {
  type        = bool
  description = "Define if JavaDeserializationRCE_URIPATH rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}

variable "aws_managed_rules_known_ad_inputs_set_Log4JRCE_excluded" {
  type        = bool
  description = "Define if Log4JRCE rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}

variable "aws_managed_rules_known_ad_inputs_set_PROPFIND_METHOD_excluded" {
  type        = bool
  description = "Define if PROPFIND_METHOD rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set."
  default     = false
}

#################### ADMIN PROTECTION RULE SET ####################
variable "aws_managed_rules_admin_protection_set_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesAdminProtectionRuleSet rule is enabled."
  default     = false
}

variable "aws_managed_rules_admin_protection_set_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesAdminProtectionRuleSet rule. This is AWS managed rule."
  default     = 110
}

variable "aws_managed_rules_admin_protection_set_AdminProtection_URIPATH_excluded" {
  type        = bool
  description = "Define if AdminProtection_URIPATH rule should be excluded (set to count) from the AWS Managed Admin Protection Set."
  default     = false
}

#################### AWS AMAZON IP REPUTATION LIST RULE SET ####################
variable "aws_managed_rules_ip_reputation_list_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesAmazonIpReputationList rule is enabled."
  default     = false
}

variable "aws_managed_rules_ip_reputation_list_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesAmazonIpReputationList rule. This is AWS managed rule."
  default     = 120
}

variable "aws_managed_rules_ip_reputation_list_AWSManagedIPReputationList_excluded" {
  type        = bool
  description = "Define if AWSManagedIPReputationList rule should be excluded (set to count) from the AWS Managed IP Reputation list."
  default     = false
}
variable "aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded" {
  type        = bool
  description = "Define if AWSManagedReconnaissanceList rule should be excluded (set to count) from the AWS Managed IP Reputation list."
  default     = false
}

#################### AWS AMAZON IP ANONYMOUS LIST RULE SET ####################
variable "aws_managed_rules_ip_anonymous_list_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesAnonymousIpList rule is enabled."
  default     = false
}

variable "aws_managed_rules_ip_anonymous_list_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesAnonymousIpList rule. This is AWS managed rule."
  default     = 130
}

variable "aws_managed_rules_ip_anonymous_list_AnonymousIPList_excluded" {
  type        = bool
  description = "Define if AnonymousIPList rule should be excluded (set to count) from the AWS Managed IP Anonymous list."
  default     = false
}
variable "aws_managed_rules_ip_anonymous_list_HostingProviderIPList_excluded" {
  type        = bool
  description = "Define if HostingProviderIPList rule should be excluded (set to count) from the AWS Managed IP Anonymous list."
  default     = false
}

#################### AWS LINUX RULE SET ####################
variable "aws_managed_rules_linux_rule_set_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesLinuxRuleSet rule is enabled."
  default     = false
}

variable "aws_managed_rules_linux_rule_set_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesLinuxRuleSet rule. This is AWS managed rule."
  default     = 140
}

variable "aws_managed_rules_linux_rule_set_LFI_COOKIE_excluded" {
  type        = bool
  description = "Define if LFI_COOKIE rule should be excluded (set to count) from the AWS Managed Linux rule set."
  default     = false
}
variable "aws_managed_rules_linux_rule_sett_LFI_QUERYSTRING_excluded" {
  type        = bool
  description = "Define if LFI_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Linux rule set."
  default     = false
}
variable "aws_managed_rules_linux_rule_sett_LFI_URIPATH_excluded" {
  type        = bool
  description = "Define if LFI_URIPATH rule should be excluded (set to count) from the AWS Managed Linux rule set."
  default     = false
}

#################### BOT CONTROL RULE SET ####################
variable "aws_managed_rules_bot_control_rule_set_enabled" {
  type        = bool
  description = "Define if AWSManagedRulesBotControlRuleSet rule is enabled."
  default     = false
}

variable "aws_managed_rules_bot_control_rule_set_priority" {
  type        = number
  description = "Define the priority for AWSManagedRulesBotControlRuleSet rule. This is AWS managed rule."
  default     = 150
}

variable "aws_managed_rules_bot_control_rule_set_CategoryAdvertising_excluded" {
  type        = bool
  description = "Define if CategoryAdvertising rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryArchiver_excluded" {
  type        = bool
  description = "Define if CategoryArchiver rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryContentFetcher_excluded" {
  type        = bool
  description = "Define if CategoryContentFetcher rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryEmailClient_excluded" {
  type        = bool
  description = "Define if CategoryEmailClient rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryHttpLibrary_excluded" {
  type        = bool
  description = "Define if CategoryHttpLibrary rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryLinkChecker_excluded" {
  type        = bool
  description = "Define if CategoryLinkChecker rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryMiscellaneous_excluded" {
  type        = bool
  description = "Define if CategoryMiscellaneous rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryMonitoring_excluded" {
  type        = bool
  description = "Define if CategoryMonitoring rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategoryScrapingFramework_excluded" {
  type        = bool
  description = "Define if CategoryScrapingFramework rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategorySearchEngine_excluded" {
  type        = bool
  description = "Define if CategorySearchEngine rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategorySecurity_excluded" {
  type        = bool
  description = "Define if CategorySecurity rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategorySeo_excluded" {
  type        = bool
  description = "Define if CategorySeo rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_CategorySocialMedia_excluded" {
  type        = bool
  description = "Define if CategorySocialMedia rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_SignalAutomatedBrowser_excluded" {
  type        = bool
  description = "Define if SignalAutomatedBrowser rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_SignalKnownBotDataCenter_excluded" {
  type        = bool
  description = "Define if SignalKnownBotDataCenter rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}
variable "aws_managed_rules_bot_control_rule_set_SignalNonBrowserUserAgent_excluded" {
  type        = bool
  description = "Define if SignalNonBrowserUserAgent rule should be excluded (set to count) from the AWS Managed Bot Control rule set."
  default     = false
}