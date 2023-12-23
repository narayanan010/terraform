resource "aws_wafv2_rule_group" "nginx-rate-limit" {
  provider = aws.primary
  name     = "${var.vertical}-${var.application}-${var.stage}-nginx-rate-limit"
  scope    = var.web_acl_scope
  capacity = 15

  rule {
    name     = "nginx-rate-limit"
    priority = 0
    action {
      block {}
    }
    statement {
        rate_based_statement {
            limit = "250"
            aggregate_key_type = "IP"
            scope_down_statement {
            not_statement {
                statement {
                ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.capterra-nginx-servers-staging-ip-set-search.arn
                }
              }
            }
          }
        }
      }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "block-nginx-rate-limit-search-stage"
        sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.vertical}-${var.application}-${var.stage}-nginx-rate-limit"
    sampled_requests_enabled   = true
  }
}
  