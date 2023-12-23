resource "aws_lb_target_group" "nlb-test-tf-import-tg" {
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

  name               = "nlb-test-tf-import-tg"
  port               = "80"
  preserve_client_ip = "false"
  protocol           = "TCP"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }

  tags_all = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }

  target_type = "ip"
  vpc_id      = "vpc-fad17781"
}

resource "aws_lb_target_group" "nlb-test-tf-import-tg2" {
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

  name               = "nlb-test-tf-import-tg2"
  port               = "443"
  preserve_client_ip = "false"
  protocol           = "TLS"
  proxy_protocol_v2  = "false"

  stickiness {
    cookie_duration = "0"
    enabled         = "false"
    type            = "source_ip"
  }

  tags = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }

  tags_all = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }

  target_type = "ip"
  vpc_id      = "vpc-fad17781"
}
