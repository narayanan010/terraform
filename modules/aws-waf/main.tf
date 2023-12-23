#*************************************************************************************************************************************************************#
#                                                      			        WAFv2 WEB ACL SECTION	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_wafv2_web_acl" "waf-acl" {
  provider    = aws.primary
  name        = "${var.vertical}-${var.web_acl_name}-${var.stage}-waf"
  scope       = var.web_acl_scope
  description = "web acl for ${var.web_acl_name}"

  default_action {
    allow {}
  }

  #################### CUSTOM RULES ####################
  ### DENYLIST ###
  dynamic rule {
    for_each = var.custom_deny_ip_list_status == "disabled" ? [] : [1]

    content {
      name     = "deny-ip-list"
      priority = var.custom_deny_ip_list_rule_priority

      dynamic action {
        for_each = var.custom_deny_ip_list_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.custom_deny_ip_list_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.deny_ip_list[0].arn
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "custom-deny-ip-list-${var.custom_deny_ip_list_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  ### ALLOWLIST ###
  dynamic rule {
    for_each = var.custom_allow_ip_list_status == "disabled" ? [] : [1]

    content {
      name     = "allow-ip-list"
      priority = var.custom_allow_ip_list_rule_priority

      dynamic action {
        for_each = var.custom_allow_ip_list_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.custom_allow_ip_list_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.allow_ip_list[0].arn
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "custom-allow-ip-list-${var.custom_allow_ip_list_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic rule {
    for_each = var.custom_allow_app_ip_list_status == "disabled" ? [] : [1]

    content {
      name     = "allow-${var.custom_app_name}-ip-list"
      priority = var.custom_allow_app_ip_list_rule_priority

      dynamic action {
        for_each = var.custom_allow_app_ip_list_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.custom_allow_app_ip_list_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      dynamic statement {
        for_each = var.custom_allow_app_ip_list_and_statement ? [] : [1]
        content {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.allow_custom_ip_list[0].arn
          }
        }
      }
      dynamic statement {
        for_each = var.custom_allow_app_ip_list_and_statement ? [1] : []
        content {
          and_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.allow_custom_ip_list[0].arn
              }
            }
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = var.custom_allow_app_ip_list_positional_constraint
                search_string         = var.custom_allow_app_ip_list_search_string
                text_transformation {
                  priority = "0"
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "custom-allow-${var.custom_app_name}-ip-list-${var.custom_allow_app_ip_list_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  ### NGINX SERVER LIST RULE ###
  dynamic rule {
    for_each = var.nginx_server_list_rule_status == "disabled" ? [] : [1]

    content {
      name     = "nginx-server-list"
      priority = var.nginx_server_list_rule_priority

      dynamic action {
        for_each = var.nginx_server_list_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.nginx_server_list_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.nginx_server_list_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.nginx_servers[0].arn
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "nginx-server-list-${var.nginx_server_list_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }


  ### CHECK OVERSIZED REQUESTS ###
  dynamic rule {
    for_each = var.oversized_body_requests_rule_status == "disabled" ? [] : [1]

    content {
      name     = "oversized-body-requests"
      priority = var.oversized_body_requests_rule_priority

      dynamic action {
        for_each = var.oversized_body_requests_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.oversized_body_requests_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.oversized_body_requests_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      statement {
        or_statement {
          statement {
            size_constraint_statement {
              comparison_operator = "GE"
              size                = 8192
              field_to_match {
                body {
                  oversize_handling = "MATCH"
                }
              }
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
          statement {
            size_constraint_statement {
              comparison_operator = "GE"
              size                = 8192
              field_to_match {
                json_body {
                  match_scope = "ALL"
                  match_pattern {
                    all {}
                  }
                  oversize_handling = "MATCH"
                }
              }
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "oversized-body-requests-${var.oversized_body_requests_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic rule {
    for_each = var.oversized_headers_requests_rule_status == "disabled" ? [] : [1]

    content {
      name     = "oversized-headers-requests"
      priority = var.oversized_headers_requests_rule_priority

      dynamic action {
        for_each = var.oversized_headers_requests_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.oversized_headers_requests_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.oversized_headers_requests_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      statement {
        size_constraint_statement {
          comparison_operator = "GE"
          size                = 8192
          field_to_match {
            headers {
              match_scope = "ALL"
              match_pattern {
                all {}
              }
              oversize_handling = "MATCH"
            }
          }
          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "oversized-headers-requests-${var.oversized_headers_requests_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic rule {
    for_each = var.oversized_cookies_requests_rule_status == "disabled" ? [] : [1]

    content {
      name     = "oversized-cookies-requests"
      priority = var.oversized_cookies_requests_rule_priority

      dynamic action {
        for_each = var.oversized_cookies_requests_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.oversized_cookies_requests_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.oversized_cookies_requests_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }
      statement {
        size_constraint_statement {
          comparison_operator = "GE"
          size                = 8192
          field_to_match {
            cookies {
              match_scope = "ALL"
              match_pattern {
                all {}
              }
              oversize_handling = "MATCH"
            }
          }
          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "oversized-cookies-requests-${var.oversized_cookies_requests_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  ### ALLOW PATH WITH SIZE ###
  dynamic rule {
    for_each = var.custom_path_size_checker_action_list

    content {
      name     = "${rule.value.action}-size-${rule.value.size_comparison_operator}-${rule.value.size}B-and-${replace(lower(rule.value.uri_path_constraint), "_", "-")}-path${replace(rule.value.uri_path, "/", "-")}"
      priority = rule.value.priority

      dynamic action {
        for_each = rule.value.action == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = rule.value.action == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = rule.value.action == "allow" ? [1] : []
        content {
          allow {}
        }
      }

      statement {
        and_statement {
          statement {
            size_constraint_statement {
              comparison_operator = rule.value.size_comparison_operator
              size                = rule.value.size
              field_to_match {
                body {
                  oversize_handling = "CONTINUE"
                }
              }
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
          statement {
            byte_match_statement {
              search_string = rule.value.uri_path
              field_to_match {
                uri_path {}
              }
              positional_constraint = rule.value.uri_path_constraint
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${rule.value.action}-size-${rule.value.size_comparison_operator}-${rule.value.size}B-and-${replace(lower(rule.value.uri_path_constraint), "_", "-")}-path${replace(rule.value.uri_path, "/", "-")}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic rule {
    for_each = var.custom_path_checker_action_list

    content {
      name     = "${rule.value.action}-${replace(lower(rule.value.uri_path_constraint), "_", "-")}-path${replace(replace(rule.value.uri_path, ".", "-"), "/", "-")}"
      priority = rule.value.priority

      dynamic action {
        for_each = rule.value.action == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = rule.value.action == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = rule.value.action == "allow" ? [1] : []
        content {
          allow {}
        }
      }

      statement {
        byte_match_statement {
          search_string = rule.value.uri_path
          field_to_match {
            uri_path {}
          }
          positional_constraint = rule.value.uri_path_constraint
          text_transformation {
            priority = 0
            type     = "NONE"
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${rule.value.action}-${replace(lower(rule.value.uri_path_constraint), "_", "-")}-path${replace(replace(rule.value.uri_path, ".", "-"), "/", "-")}"
        sampled_requests_enabled   = true
      }
    }
  }


  ### CLOUDFRONT EMPTY USER AGENT RULE ###
  dynamic rule {
    for_each = var.cloudfront_empty_user_agent_rule_status == "disabled" ? [] : [1]

    content {
      name     = "cloudfront-empty-user-agent"
      priority = var.cloudfront_empty_user_agent_rule_priority

      dynamic action {
        for_each = var.cloudfront_empty_user_agent_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.cloudfront_empty_user_agent_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.cloudfront_empty_user_agent_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }

      statement {
        not_statement {
          statement {
            size_constraint_statement {
              comparison_operator = "GT"
              size                = 0

              field_to_match {
                single_query_argument {
                  name = "user-agent"
                }
              }
              text_transformation {
                priority = 0
                type     = "NONE"
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "cloudfront-empty-user-agent-${var.cloudfront_empty_user_agent_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  ### RATE LIMIT RULE ###
  dynamic rule {
    for_each = var.rate_limit_rule_status == "disabled" ? [] : [1]

    content {
      name     = "rate-limit"
      priority = var.rate_limit_rule_priority

      dynamic action {
        for_each = var.rate_limit_rule_status == "count" ? [1] : []
        content {
          count {}
        }
      }
      dynamic action {
        for_each = var.rate_limit_rule_status == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic action {
        for_each = var.rate_limit_rule_status == "allow" ? [1] : []
        content {
          allow {}
        }
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit_rule_value
          aggregate_key_type = var.rate_limit_rule_aggregate_key_type

          dynamic forwarded_ip_config {
            for_each = var.rate_limit_rule_aggregate_key_type == "FORWARDED_IP" ? [1] : []
            content {
              header_name       = var.rate_limit_rule_forwarded_ip_header_name
              fallback_behavior = var.rate_limit_rule_forwarded_ip_fallback_behaviour
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "rate-limit-${var.rate_limit_rule_status}"
        sampled_requests_enabled   = true
      }
    }
  }

  #################### CUSTOM RULE GROUP ####################
  dynamic rule {
    for_each = var.custom_rule_group_list

    content {
      name     = "${split("/",lower(rule.value.rule_group_arn))[2]}"
      priority = rule.value.priority

      override_action {
        none {}
      }
      statement {
        rule_group_reference_statement {
          arn = rule.value.rule_group_arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "${split("/",lower(rule.value.rule_group_arn))[2]}"
        sampled_requests_enabled   = false
      }
    }
  }

  #################### AWS MANAGED RULES ####################
  ### AWS COMMON RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_common_rule_set_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = var.aws_managed_rules_common_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"

          ### RULES TO BE SET AS COUNT ###

          ### CrossSiteScripting ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_CrossSiteScripting_BODY_excluded ? [1] : []
            content {
              name = "CrossSiteScripting_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_CrossSiteScripting_COOKIE_excluded ? [1] : []
            content {
              name = "CrossSiteScripting_COOKIE"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_CrossSiteScripting_QUERYARGUMENTS_excluded ? [1] : []
            content {
              name = "CrossSiteScripting_QUERYARGUMENTS"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_CrossSiteScripting_URIPATH_excluded ? [1] : []
            content {
              name = "CrossSiteScripting_URIPATH"
            }
          }

          ### EC2MetaDataSSR ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_EC2MetaDataSSRF_BODY_excluded ? [1] : []
            content {
              name = "EC2MetaDataSSRF_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_EC2MetaDataSSRF_COOKIE_excluded ? [1] : []
            content {
              name = "EC2MetaDataSSRF_COOKIE"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_EC2MetaDataSSRF_QUERYARGUMENTS_excluded ? [1] : []
            content {
              name = "EC2MetaDataSSRF_QUERYARGUMENTS"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_EC2MetaDataSSRF_URIPATH_excluded ? [1] : []
            content {
              name = "EC2MetaDataSSRF_URIPATH"
            }
          }

          ### GenericLFI ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericLFI_BODY_excluded ? [1] : []
            content {
              name = "GenericLFI_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericLFI_QUERYARGUMENTS_excluded ? [1] : []
            content {
              name = "GenericLFI_QUERYARGUMENTS"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericLFI_URIPATH_excluded ? [1] : []
            content {
              name = "GenericLFI_URIPATH"
            }
          }

          ### GenericRFI ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericRFI_BODY_excluded ? [1] : []
            content {
              name = "GenericRFI_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericRFI_QUERYARGUMENTS_excluded ? [1] : []
            content {
              name = "GenericRFI_QUERYARGUMENTS"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_GenericRFI_URIPATH_excluded ? [1] : []
            content {
              name = "GenericRFI_URIPATH"
            }
          }

          ### NoUserAgent ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_NoUserAgent_HEADER_excluded ? [1] : []
            content {
              name = "NoUserAgent_HEADER"
            }
          }

          ### RestrictedExtensions ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_RestrictedExtensions_URIPATH_excluded ? [1] : []
            content {
              name = "RestrictedExtensions_URIPATH"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_RestrictedExtensions_QUERYARGUMENTS_excluded ? [1] : []
            content {
              name = "RestrictedExtensions_QUERYARGUMENTS"
            }
          }

          ### SizeRestrictions ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_SizeRestrictions_BODY_excluded ? [1] : []
            content {
              name = "SizeRestrictions_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_SizeRestrictions_Cookie_HEADER_excluded ? [1] : []
            content {
              name = "SizeRestrictions_Cookie_HEADER"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_SizeRestrictions_QUERYSTRING_excluded ? [1] : []
            content {
              name = "SizeRestrictions_QUERYSTRING"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_SizeRestrictions_URIPATH_excluded ? [1] : []
            content {
              name = "SizeRestrictions_URIPATH"
            }
          }

          ### UserAgent_BadBots ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded ? [1] : []
            content {
              name = "UserAgent_BadBots_HEADER"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  ### AWS KNOWN BAD INPUTS RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_known_bad_inputs_set_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = var.aws_managed_rules_known_bad_inputs_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
          version     = "Version_1.14"

          ### ExploitablePaths ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_ExploitablePaths_URIPATH_excluded ? [1] : []
            content {
              name = "ExploitablePaths_URIPATH"
            }
          }

          ### Host_localhost ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_Host_localhost_HEADER_excluded ? [1] : []
            content {
              name = "Host_localhost_HEADER"
            }
          }

          ### JavaDeserializationRCE ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_BODY_excluded ? [1] : []
            content {
              name = "JavaDeserializationRCE_BODY"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_HEADER_excluded ? [1] : []
            content {
              name = "JavaDeserializationRCE_HEADER"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_QUERYSTRING_excluded ? [1] : []
            content {
              name = "JavaDeserializationRCE_QUERYSTRING"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_URIPATH_excluded ? [1] : []
            content {
              name = "JavaDeserializationRCE_URIPATH"
            }
          }

          ### Log4JRCE ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_Log4JRCE_excluded ? [1] : []
            content {
              name = "Log4JRCE"
            }
          }

          ### PROPFIND_METHOD ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_known_ad_inputs_set_PROPFIND_METHOD_excluded ? [1] : []
            content {
              name = "PROPFIND_METHOD"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  ### AWS ADMIN PROTECTION RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_admin_protection_set_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesAdminProtectionRuleSet"
      priority = var.aws_managed_rules_admin_protection_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAdminProtectionRuleSet"
          vendor_name = "AWS"

          ### ExploitablePaths ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_admin_protection_set_AdminProtection_URIPATH_excluded ? [1] : []
            content {
              name = "AdminProtection_URIPATH"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAdminProtectionRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  ### AWS AMAZON IP REPUTATION LIST RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_ip_reputation_list_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = var.aws_managed_rules_ip_reputation_list_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAmazonIpReputationList"
          vendor_name = "AWS"

          ### AWSManagedIP ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_ip_reputation_list_AWSManagedIPReputationList_excluded ? [1] : []
            content {
              name = "AWSManagedIPReputationList"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded ? [1] : []
            content {
              name = "AWSManagedReconnaissanceList"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
      }
    }
  }

  ### AWS ANONYMOUS IP LIST RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_ip_anonymous_list_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesAnonymousIpList"
      priority = var.aws_managed_rules_ip_anonymous_list_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAnonymousIpList"
          vendor_name = "AWS"

          ### IPList ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_ip_anonymous_list_AnonymousIPList_excluded ? [1] : []
            content {
              name = "AnonymousIPList"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_ip_anonymous_list_HostingProviderIPList_excluded ? [1] : []
            content {
              name = "HostingProviderIPList"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAnonymousIpList"
        sampled_requests_enabled   = true
      }
    }
  }

  ### AWS LINUX RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_linux_rule_set_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesLinuxRuleSet"
      priority = var.aws_managed_rules_linux_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesLinuxRuleSet"
          vendor_name = "AWS"

          ### LFI ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_linux_rule_set_LFI_COOKIE_excluded ? [1] : []
            content {
              name = "LFI_COOKIE"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_linux_rule_sett_LFI_QUERYSTRING_excluded ? [1] : []
            content {
              name = "LFI_QUERYSTRING"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_linux_rule_sett_LFI_URIPATH_excluded ? [1] : []
            content {
              name = "LFI_URIPATH"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesLinuxRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  ### BOT CONTROL RULE SET - PAID RULE SET ###
  dynamic rule {
    for_each = var.aws_managed_rules_bot_control_rule_set_enabled ? [1] : []
    content {
      name     = "AWSManagedRulesBotControlRuleSet"
      priority = var.aws_managed_rules_bot_control_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          ### Category ###
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryAdvertising_excluded ? [1] : []
            content {
              name = "CategoryAdvertising"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryArchiver_excluded ? [1] : []
            content {
              name = "CategoryArchiver"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryContentFetcher_excluded ? [1] : []
            content {
              name = "CategoryContentFetcher"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryEmailClient_excluded ? [1] : []
            content {
              name = "CategoryEmailClient"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryHttpLibrary_excluded ? [1] : []
            content {
              name = "CategoryHttpLibrary"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryLinkChecker_excluded ? [1] : []
            content {
              name = "CategoryLinkChecker"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryMiscellaneous_excluded ? [1] : []
            content {
              name = "CategoryMiscellaneous"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryMonitoring_excluded ? [1] : []
            content {
              name = "CategoryMonitoring"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategoryScrapingFramework_excluded ? [1] : []
            content {
              name = "CategoryScrapingFramework"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategorySearchEngine_excluded ? [1] : []
            content {
              name = "CategorySearchEngine"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategorySecurity_excluded ? [1] : []
            content {
              name = "CategorySecurity"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategorySeo_excluded ? [1] : []
            content {
              name = "CategorySeo"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_CategorySocialMedia_excluded ? [1] : []
            content {
              name = "CategorySocialMedia"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_SignalAutomatedBrowser_excluded ? [1] : []
            content {
              name = "SignalAutomatedBrowser"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_SignalKnownBotDataCenter_excluded ? [1] : []
            content {
              name = "SignalKnownBotDataCenter"
            }
          }
          dynamic excluded_rule {
            for_each = var.aws_managed_rules_bot_control_rule_set_SignalNonBrowserUserAgent_excluded ? [1] : []
            content {
              name = "SignalNonBrowserUserAgent"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesBotControlRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "web_acl_metric"
    sampled_requests_enabled   = true
  }
}
