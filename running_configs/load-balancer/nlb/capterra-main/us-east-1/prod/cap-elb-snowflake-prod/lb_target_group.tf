resource "aws_lb_target_group" "TG-snowflake-prod" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "TG-snowflake-prod"
  port               = "22"
  preserve_client_ip = "true"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }

  tags_all = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }

  target_type = "instance"
  vpc_id      = "vpc-c2ecc1a4"
}

resource "aws_lb_target_group" "tg-edg1-prod-equinix" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "tg-edg1-prod-equinix"
  port               = "1521"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  target_type = "ip"
  vpc_id      = "vpc-c2ecc1a4"
}

resource "aws_lb_target_group" "tg-edg2-prod-equinix" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "tg-edg2-prod-equinix"
  port               = "1521"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  target_type = "ip"
  vpc_id      = "vpc-c2ecc1a4"
}

resource "aws_lb_target_group" "tg-or5-prod" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "tg-or5-prod"
  port               = "1521"
  preserve_client_ip = "true"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  target_type = "instance"
  vpc_id      = "vpc-c2ecc1a4"
}

resource "aws_lb_target_group" "tg-or5dg2-prod" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    #timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "tg-or5dg2-prod"
  port               = "1521"
  preserve_client_ip = "true"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  target_type = "instance"
  vpc_id      = "vpc-c2ecc1a4"
}