resource "aws_wafv2_rule_group" "spammer" {
  provider = aws.primary
  name     = "${var.vertical}-${var.application}-${var.stage}-custom-spammer"
  scope    = var.web_acl_scope
  capacity = 20

  rule {
    name     = "custom-spammer"
    priority = 0

    action {
      block {}
    }

    statement {
      and_statement {
        statement {
          byte_match_statement {
            search_string = "https://reviews.capterra.com/new/136078?utm_industry=ind96&utm_source=end-user&utm_campaign=ps-518&utm_content=6mo&utm_medium=social-reviews&utm_term=08b_mobile_a"
            field_to_match {
              single_header {
                name  = "referer"
              }
            }
            positional_constraint = "EXACTLY"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          byte_match_statement {
            search_string = "CEO"
            field_to_match {
              json_body {
                match_pattern {
                  included_paths = [
                    "/reviewerJobTitle"
                    ]
                }
                match_scope  = "ALL"
                oversize_handling  = "CONTINUE"
              }
            }
            positional_constraint = "EXACTLY"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          byte_match_statement {
            search_string = "129067"
            field_to_match {
              json_body {
                match_pattern {
                  included_paths = [
                    "/productId"
                    ]
                }
                match_scope  = "ALL"
                oversize_handling  = "CONTINUE"
              }
            }
            positional_constraint = "EXACTLY"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
        statement {
          byte_match_statement {
            search_string = "0"
            field_to_match {
              json_body {
                match_pattern {
                  included_paths = [
                    "/userMetaData/prosFieldKeystrokes",
                    "/userMetaData/consFieldKeystrokes",
                    "/userMetaData/generalFieldKeystrokes"
                    ]
                }
                match_scope  = "ALL"
                oversize_handling  = "CONTINUE"
              }
            }
            positional_constraint = "EXACTLY"
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
      metric_name                = "custom-spammer"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.vertical}-${var.application}-${var.stage}-custom-spammer"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_rule_group" "method_regex" {
  provider = aws.primary
  name     = "${var.vertical}-${var.application}-${var.stage}-method-regex"
  scope    = var.web_acl_scope
  capacity = 15

  rule {
    name     = "allow-put-post-size-GE-8192B-and-contains-path-k8s-api"
    priority = 0
    action {
      allow {}
    }
    statement {
      and_statement {
        statement {
          size_constraint_statement {
            field_to_match {
              body {
                oversize_handling = "CONTINUE"
              }
            }
            comparison_operator = "GE"
            size = 8192
            text_transformation {
              priority = 0
              type = "NONE"
            }
          }
        }
        statement {
          regex_match_statement {
            regex_string = "[PUT]|[POST]"
            field_to_match {
              method {}
            }
            text_transformation {
              priority = 0
              type = "NONE"
            }
          }
        }
        statement {
          byte_match_statement {
            search_string = "/k8s/api"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type = "NONE"
            }
            positional_constraint = "CONTAINS"
          }
        }
      }
    }
    visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "allow-put-post-size-GE-8192B-and-contains-path-k8s-api"
        sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.vertical}-${var.application}-${var.stage}-method-regex"
    sampled_requests_enabled   = true
  }
}