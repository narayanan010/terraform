resource "aws_wafv2_web_acl" "mainsite-acl-prod-us-east-1" {
  provider    = aws
  description = "Mainsite ALB Web ACL"
  name        = "mainsite-acl-prod-us-east-1"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = "6"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        excluded_rule {
          name = "AWSManagedIPReputationList"
        }

        name = "AWSManagedRulesAmazonIpReputationList"

        scope_down_statement {
          or_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/saml/consume"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/vendor_countries/locations.json"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = "7"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        excluded_rule {
          name = "AnonymousIPList"
        }

        excluded_rule {
          name = "HostingProviderIPList"
        }

        name = "AWSManagedRulesAnonymousIpList"

        scope_down_statement {
          or_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/saml/consume"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/vendor_countries/locations.json"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = "9"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        excluded_rule {
          name = "CategoryAdvertising"
        }

        excluded_rule {
          name = "CategoryArchiver"
        }

        excluded_rule {
          name = "CategoryContentFetcher"
        }

        excluded_rule {
          name = "CategoryHttpLibrary"
        }

        excluded_rule {
          name = "CategoryLinkChecker"
        }

        excluded_rule {
          name = "CategoryMiscellaneous"
        }

        excluded_rule {
          name = "CategoryMonitoring"
        }

        excluded_rule {
          name = "CategoryScrapingFramework"
        }

        excluded_rule {
          name = "CategorySearchEngine"
        }

        excluded_rule {
          name = "CategorySecurity"
        }

        excluded_rule {
          name = "CategorySeo"
        }

        excluded_rule {
          name = "CategorySocialMedia"
        }

        excluded_rule {
          name = "SignalAutomatedBrowser"
        }

        excluded_rule {
          name = "SignalKnownBotDataCenter"
        }

        excluded_rule {
          name = "SignalNonBrowserUserAgent"
        }

        name = "AWSManagedRulesBotControlRuleSet"

        scope_down_statement {
          or_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/saml/consume"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/vendor_countries/locations.json"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = "12"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        excluded_rule {
          name = "CrossSiteScripting_BODY"
        }

        excluded_rule {
          name = "CrossSiteScripting_COOKIE"
        }

        excluded_rule {
          name = "GenericLFI_URIPATH"
        }

        excluded_rule {
          name = "SizeRestrictions_BODY"
        }

        excluded_rule {
          name = "SizeRestrictions_Cookie_HEADER"
        }

        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }

        excluded_rule {
          name = "SizeRestrictions_URIPATH"
        }

        name = "AWSManagedRulesCommonRuleSet"

        scope_down_statement {
          and_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      body {
                        oversize_handling = "CONTINUE"
                      }
                    }

                    positional_constraint = "CONTAINS"
                    search_string         = "One"

                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/add_a_product"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        vendor_name = "AWS"
        version     = "Version_1.3"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = "true"
    }
  }
  
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = "10"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesKnownBadInputsRuleSet"

        scope_down_statement {
          or_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/saml/consume"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "CONTAINS"
                    search_string         = "/vp/vendor_countries/locations.json"
                    field_to_match {
                      query_string {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = "8"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesLinuxRuleSet"

        scope_down_statement {
          not_statement {
            statement {
              byte_match_statement {
                positional_constraint = "CONTAINS"
                search_string         = "/vp/summon_xyzzy"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = "0"
                  type     = "NONE"
                }
              }
            }
          }
        }

        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "June6Incident"
    priority = "5"
    action {
      count {}
    }
    statement {
      ip_set_reference_statement {
        arn = "arn:aws:wafv2:us-east-1:176540105868:regional/ipset/June6Incident/9b779429-480d-4631-8635-05c2ba66bcd6"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "June6Incident"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "Whitelist-Requests-With-Header"
    priority = "4"
    action {
      count {}
    }
    statement {
      and_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "authority"
              }
            }

            positional_constraint = "EXACTLY"
            search_string         = "blog.capterra.com"

            text_transformation {
              priority = "0"
              type     = "NONE"
            }
          }
        }

        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "x-capterra-blog"
              }
            }

            positional_constraint = "EXACTLY"
            search_string         = "9Mq6S9NP79"

            text_transformation {
              priority = "0"
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "Whitelist-Requests-With-Header"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "mainsite-prod-rate-based-rule-us-east-1"
    priority = "3"

    action {
      block {}
    }
    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = "250"

        scope_down_statement {
          and_statement {
            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      single_header {
                        name = "lytics-id"
                      }
                    }

                    positional_constraint = "EXACTLY"
                    search_string         = "7dafa3f5f9e8efd6782940aa05719f12"

                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  byte_match_statement {
                    field_to_match {
                      single_header {
                        name = "user-agent"
                      }
                    }

                    positional_constraint = "EXACTLY"
                    search_string         = "lyticsbot"

                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = "arn:aws:wafv2:us-east-1:176540105868:regional/ipset/OnCrawl/12b764a9-1b67-4ab8-828a-0671c904b60c"
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = "arn:aws:wafv2:us-east-1:176540105868:regional/ipset/SEO_Team/40d3dfdd-047b-4d18-a579-d1e487bbaa04"
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = "arn:aws:wafv2:us-east-1:176540105868:regional/ipset/Tech_Team/59060649-9246-4903-b363-6f12d48ad68a"
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = "arn:aws:wafv2:us-east-1:176540105868:regional/ipset/WordPress_Crawl/212e116c-a6b9-4325-92a0-c5e96261e30b"
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "mainsite-prod-rate-based-rule-us-east-1"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "oversized-body-requests"
    priority = "0"
    action {
      block {}
    }
    statement {
      and_statement {
        statement {
          not_statement {
            statement {
              or_statement {
                statement {
                  byte_match_statement {
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/T6dY78t8/xhr/api"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }

                statement {
                  byte_match_statement {
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/T6dY78t8/xhr/assets"
                    field_to_match {
                      uri_path {}
                    }                    
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }

                statement {
                  byte_match_statement {
                    positional_constraint = "STARTS_WITH"
                    search_string         = "/vp/api/"
                    field_to_match {
                      uri_path {}
                    }
                    text_transformation {
                      priority = "0"
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }

        statement {
          or_statement {
            statement {
              size_constraint_statement {
                comparison_operator = "GE"

                field_to_match {
                  body {
                    oversize_handling = "MATCH"
                  }
                }

                size = "8192"

                text_transformation {
                  priority = "0"
                  type     = "NONE"
                }
              }
            }

            statement {
              size_constraint_statement {
                comparison_operator = "GE"

                field_to_match {
                  json_body {
                    match_pattern {
                      all {}
                    }
                    match_scope       = "ALL"
                    oversize_handling = "MATCH"
                  }
                }

                size = "8192"

                text_transformation {
                  priority = "0"
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "oversized-body-requests-block"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "oversized-cookies-requests"
    priority = "2"
    action {
      block {}
    }
    statement {
      size_constraint_statement {
        comparison_operator = "GE"

        field_to_match {
          cookies {
            match_pattern {
              all {}
            }
            match_scope       = "ALL"
            oversize_handling = "MATCH"
          }
        }

        size = "8192"

        text_transformation {
          priority = "0"
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "oversized-cookies-requests-block"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "oversized-headers-requests"
    priority = "1"
    action {
      block {}
    }
    statement {
      size_constraint_statement {
        comparison_operator = "GE"

        field_to_match {
          headers {
            match_pattern {
              all {}
            }
            match_scope       = "ALL"
            oversize_handling = "MATCH"
          }
        }

        size = "8192"

        text_transformation {
          priority = "0"
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "oversized-headers-requests-block"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "xss-body-rulegroup-vp-prod"
    priority = "11"
    override_action {
      none {}
    }
    statement {
      rule_group_reference_statement {
        arn = "arn:aws:wafv2:us-east-1:176540105868:regional/rulegroup/xss-body-rulegroup-vp-prod/8c47fe36-4448-4aa6-9599-8a742ae48311"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "xss-body-rulegroup-vp-prod"
      sampled_requests_enabled   = "true"
    }
  }

  scope = "REGIONAL"

  visibility_config {
    cloudwatch_metrics_enabled = "true"
    metric_name                = "mainsite-acl-prod-us-east-1"
    sampled_requests_enabled   = "true"
  }
}