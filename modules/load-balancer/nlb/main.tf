terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.14.0"
    }
  }
  required_version = ">= 1.1.5"
}

#Network Load Balancer

resource "aws_alb" "nlb" {
  count                            = var.create_nlb ? 1 : 0
  provider                         = aws
  name                             = var.nlb_name
  internal                         = var.internal
  subnets                          = var.ec2_subnets
  load_balancer_type               = var.load_balancer_type
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  enable_waf_fail_open             = var.enable_waf_fail_open
  desync_mitigation_mode           = var.desync_mitigation_mode
  dynamic "access_logs" {
    for_each = length(keys(var.lb_logs)) == 0 ? [] : [var.lb_logs]
    content {
      bucket  = lookup(var.lb_logs, "bucket", null)
      enabled = lookup(var.lb_logs, "enabled", null)
      prefix  = lookup(var.lb_logs, "prefix", null)
    }
  }
}

#Target Group

resource "aws_alb_target_group" "nlb-tg" {
  provider    = aws
  count       = var.create_nlb ? length(var.target_groups) : 0
  name        = lookup(var.target_groups[count.index], "name", null)
  vpc_id      = var.vpc_id
  port        = lookup(var.target_groups[count.index], "backend_port", null)
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null) != null ? upper(lookup(var.target_groups[count.index], "backend_protocol")) : null
  target_type = lookup(var.target_groups[count.index], "target_type", null)
  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }
  depends_on = [
    aws_alb.nlb
  ]
}

locals {
  # Merge the target group index into a product map of the targets so we
  # can figure out what target group we should attach each target to.
  # Target indexes can be dynamically defined, but need to match
  # the function argument reference. This means any additional arguments
  # can be added later and only need to be updated in the attachment resource below.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment#argument-reference
  target_group_attachments = merge(flatten([
    for index, group in var.target_groups : [
      for k, targets in group : {
        for target_key, target in targets : join(".", [index, target_key]) => merge({ tg_index = index }, target)
      }
      if k == "targets"
    ]
  ])...)
}

#Target Group Attachments

resource "aws_alb_target_group_attachment" "this" {
  for_each          = { for k, v in local.target_group_attachments : k => v if var.create_nlb }
  provider          = aws
  target_group_arn  = aws_alb_target_group.nlb-tg[each.value.tg_index].arn
  target_id         = each.value.target_id
  port              = lookup(each.value, "port", null)
  availability_zone = lookup(each.value, "availability_zone", null)
  depends_on = [
    aws_alb_target_group.nlb-tg
  ]
}

#Listener

resource "aws_alb_listener" "frontend_http_tcp" {
  count             = var.create_nlb ? length(var.http_tcp_listeners) : 0
  provider          = aws
  load_balancer_arn = aws_alb.nlb[0].arn
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]
  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]
    # Defaults to forward action if action_type not specified
    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "action_type", "")) ? aws_alb_target_group.nlb-tg[lookup(default_action.value, "target_group_index", count.index)].id : null
      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]
        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }
      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]
        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
  depends_on = [
    aws_alb.nlb
  ]
}

data "aws_acm_certificate" "acm_https" {
  count    = var.acm_data_block ? 1 : 0
  provider = aws
  domain   = var.acm_domain
  statuses = ["ISSUED"]
}

resource "aws_alb_listener" "frontend_https" {
  count             = var.create_nlb ? length(var.https_listeners) : 0
  provider          = aws
  load_balancer_arn = aws_alb.nlb[0].arn
  port              = var.https_listeners[count.index]["port"]
  protocol          = lookup(var.https_listeners[count.index], "protocol", "HTTPS")
  certificate_arn   = data.aws_acm_certificate.acm_https[0].arn
  ssl_policy        = lookup(var.https_listeners[count.index], "ssl_policy", "ELBSecurityPolicy-2016-08")
  alpn_policy       = lookup(var.https_listeners[count.index], "alpn_policy", null)
  dynamic "default_action" {
    for_each = length(keys(var.https_listeners[count.index])) == 0 ? [] : [var.https_listeners[count.index]]
    # Defaults to forward action if action_type not specified
    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, "", "forward"], lookup(default_action.value, "action_type", "")) ? aws_alb_target_group.nlb-tg[lookup(default_action.value, "target_group_index", count.index)].id : null
      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]
        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }
      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [lookup(default_action.value, "fixed_response", {})]
        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
  depends_on = [
    aws_alb.nlb
  ]
}

resource "aws_vpc_endpoint_service" "nlb_sandbox_pvt_link" {
  count                      = var.create_pvt_link ? 1 : 0
  acceptance_required        = true
  network_load_balancer_arns = [aws_alb.nlb[0].arn]
  provider                   = aws
  depends_on = [
    aws_alb.nlb
  ]
}

data "aws_secretsmanager_secret_version" "datadog" {
  secret_id = "datadog-tf"
}

provider "datadog" {
  api_key = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_key"]
  app_key = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["app_key"]
}

resource "datadog_monitor" "unhealthy_hosts" {
  count              = var.dd_alerts_to == "" ? 0 : 1
  name               = "[${var.stage}] Unhealthy targets for ${aws_alb.nlb[0].name}"
  type               = "metric alert"
  message            = "${var.dd_alerts_to}: Unhealthy targets on {loadbalancer} is non-zero"
  escalation_message = "${var.dd_alerts_to}: Unhealthy targets on {loadbalancer} remains elevated"

  query = "avg(last_30m):anomalies(avg:aws.networkelb.un_healthy_host_count{loadbalancer:${aws_alb.nlb[0].arn_suffix}}, 'agile', 2, direction='above', interval=60, alert_window='last_30m', seasonality='hourly', timezone='utc', count_default_zero='true') >= 0"

  monitor_threshold_windows {
    recovery_window = "last_15m"
    trigger_window  = "last_30m"
  }

  include_tags = true

  renotify_interval = 120
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = [var.stage, var.vertical]
}

