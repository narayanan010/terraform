resource "aws_lb_target_group" "TG-steam-FWKNOP" {
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "22"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "TG-steam-FWKNOP"
  port               = "62201"
  preserve_client_ip = "true"
  protocol           = "UDP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  target_type = "instance"
  vpc_id      = "vpc-c2ecc1a4"
}

resource "aws_lb_target_group" "TG-steam-SSH" {
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "3"
    interval            = "30"
    port                = "22"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "3"
  }

  name               = "TG-steam-SSH"
  port               = "22"
  preserve_client_ip = "true"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  target_type = "instance"
  vpc_id      = "vpc-c2ecc1a4"
}