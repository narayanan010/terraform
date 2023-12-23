resource "aws_lb_target_group" "tg-np1-equinix" {
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

  name               = "tg-np1-equinix"
  port               = "1518"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "true"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  target_type = "ip"
  vpc_id      = "vpc-60714d06"
}

resource "aws_lb_target_group" "tg-astg2" {
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

  name               = "tg-astg2"
  port               = "1521"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "true"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  target_type = "instance"
  vpc_id      = "vpc-60714d06"
}

resource "aws_lb_target_group" "tg-astg3" {
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

  name               = "tg-astg3"
  port               = "1521"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "true"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  tags_all = {
    CreatorAutoTag = "sgupta"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
    ENVIRONMENT    = "staging"
    created_by     = "sarvesh.gupta@gartner.com"
  }

  target_type = "instance"
  vpc_id      = "vpc-60714d06"
}

resource "aws_lb_target_group" "tg-astg7" {
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

  name               = "tg-astg7"
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
  vpc_id      = "vpc-60714d06"
}
