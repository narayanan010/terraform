resource "aws_wafv2_web_acl_logging_configuration" "mainsite-acl-prod-us-east-1-log-config" {
  provider                = aws
  log_destination_configs = ["arn:aws:s3:::aws-waf-logs-capterra-main-prod-us-east-1"]
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
  resource_arn = "arn:aws:wafv2:us-east-1:176540105868:regional/webacl/mainsite-acl-prod-us-east-1/71eede4a-5311-4eac-a204-7647265afe62"
}