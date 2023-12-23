resource "aws_wafv2_web_acl_logging_configuration" "mainsite-acl-prod-us-west-2-log-config" {
  provider                = aws
  log_destination_configs = ["arn:aws:s3:::aws-waf-logs-capterra-main-prod-dr-us-west-2"]
  logging_filter {
    default_behavior = "DROP"
    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "BLOCK"
        }
      }
      requirement = "MEETS_ALL"
    }
    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "CAPTCHA"
        }
      }
      requirement = "MEETS_ALL"
    }
    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "COUNT"
        }
      }
      requirement = "MEETS_ALL"
    }
  }
  resource_arn = "arn:aws:wafv2:us-west-2:176540105868:regional/webacl/mainsite-acl-prod-us-west-2/301c4f19-ee14-4c1f-9d34-46bedf90951d"
}