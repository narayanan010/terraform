resource "aws_wafv2_web_acl_logging_configuration" "mainsite-acl-staging-ue1-log_config" {
  provider = aws
  log_destination_configs = ["arn:aws:s3:::aws-waf-logs-capterra-main-staging-us-east-1"]

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

  resource_arn = "arn:aws:wafv2:us-east-1:176540105868:regional/webacl/mainsite-acl-staging-ue1/da115c14-ae34-44d4-b073-01b824a02d9b"
}