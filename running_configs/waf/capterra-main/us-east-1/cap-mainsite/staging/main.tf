resource "aws_wafv2_web_acl" "mainsite-acl-staging-ue1" {
  provider = aws
  name = "mainsite-acl-staging-ue1"

  default_action{
    allow{}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = "6"
    override_action {
      none {}
    }    
    statement {
      managed_rule_group_statement {

        rule_action_override {
          action_to_use {
            count {}
          }
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
    name = "Browserstack-header-whitelist"
    priority = "0"
    action {
      allow {}
    }
    statement {
      byte_match_statement {
        search_string = var.bstack_search_string
        positional_constraint = "EXACTLY"
        field_to_match {
          single_header {
            name = "x-capstg-key"
          }
        }
        text_transformation {
          priority = "0"
          type     = "NONE"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "Browserstack-header-whitelist"
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
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "AnonymousIPList"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
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
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = "11"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CrossSiteScripting_BODY"
        }
        
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CrossSiteScripting_COOKIE"
        }
        
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "GenericLFI_URIPATH"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_Cookie_HEADER"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_URIPATH"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "NoUserAgent_HEADER"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "EC2MetaDataSSRF_QUERYARGUMENTS"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "GenericLFI_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "UserAgent_BadBots_HEADER"
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
    priority = "9"
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "JavaDeserializationRCE_BODY"
        }
        
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "PROPFIND_METHOD"
        }
        
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "Log4JRCE_HEADER"
        }
        
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
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "LFI_URIPATH"
        }

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
    name     = "Whitelist-Requests-With-Header"
    priority = "5"
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
            search_string         = "blog.capstage.net"

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
            search_string         = var.blog_search_string

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
    name     = "mainsite-rate-limit-ue1"
    priority = "4"
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
                    search_string         = var.lytics_search_string

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

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.mainsite-stage-browserstack-ip-set.arn
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.mainsite-stage-allow-prod-nginx-ip-set.arn
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
      metric_name                = "mainsite-rate-limit-ue1"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "oversized-body-requests"
    priority = "1"
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
    priority = "3"
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
    priority = "2"
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
    name     = "xss-body-rulegroup-vp-staging"
    priority = "10"
    override_action {
      none {}
    }
    statement {
      rule_group_reference_statement {
        arn = "arn:aws:wafv2:us-east-1:176540105868:regional/rulegroup/xss-body-rulegroup-vp-staging/c5bea7fa-3d6b-481d-97bd-ea0a444ee42b"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "xss-body-rulegroup-vp-staging"
      sampled_requests_enabled   = "true"
    }
  }

  scope = "REGIONAL"

  visibility_config {
    cloudwatch_metrics_enabled = "true"
    metric_name                = "mainsite-acl-staging-ue1"
    sampled_requests_enabled   = "true"
  }
}
