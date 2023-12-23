#*************************************************************************************************************************************************************#
#                                                      			        WAFv2 LOGGING SECTION	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_wafv2_web_acl_logging_configuration" "waf-acl-logging" {
  provider                = aws.primary
  count                   = var.waf_logging_enabled ? 1 : 0
  log_destination_configs = var.waf_logging_destination == "" ? [aws_cloudwatch_log_group.waf-log-group[0].arn] : [var.waf_logging_destination]
  resource_arn            = aws_wafv2_web_acl.waf-acl.arn

  dynamic redacted_fields {
    for_each = var.waf_logging_redacted_field_single_header ? [1] : []
    content {
      single_header {
        name = var.waf_logging_redacted_field_single_header_name
      }
    }
  }
  dynamic redacted_fields {
    for_each = var.waf_logging_redacted_field_method ? [1] : []
    content {
      method {}
    }
  }
  dynamic redacted_fields {
    for_each = var.waf_logging_redacted_field_query_string ? [1] : []
    content {
      query_string {}
    }
  }
  dynamic redacted_fields {
    for_each = var.waf_logging_redacted_field_uri_path ? [1] : []
    content {
      uri_path {}
    }
  }

  dynamic logging_filter {
    for_each = var.waf_logging_filter_enabled ? [1] : []

    content {
      default_behavior = var.waf_logging_filter_default_behavior

      dynamic filter {
        for_each = var.waf_logging_filters

        content {
          behavior    = filter.value.behavior
          requirement = filter.value.requirement

          dynamic condition {
            for_each = filter.value.conditions

            content {
              dynamic action_condition {
                for_each = condition.value.type == "action_condition" ? [1] : []

                content {
                  action = condition.value.effect
                }

              }
              dynamic label_name_condition {
                for_each = condition.value.type == "label_name_condition" ? [1] : []

                content {
                  label_name = condition.value.effect
                }

              }
            }
          }
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "waf-log-group" {
  provider          = aws.primary
  count             = var.waf_logging_destination == "" ? 1 : 0
  name              = "aws-waf-logs-${var.vertical}-${var.web_acl_name}-${var.stage}-${var.web_acl_scope}"
  retention_in_days = var.waf_logging_retention != 0 ? var.waf_logging_retention : 30
  kms_key_id        = var.waf_logging_kms_key != "" ? var.waf_logging_kms_key : null
}
