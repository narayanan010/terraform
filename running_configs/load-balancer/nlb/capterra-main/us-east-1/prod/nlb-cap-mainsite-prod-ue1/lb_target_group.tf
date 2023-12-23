resource "aws_lb_target_group" "tg-capterra-mainsite-prd-ue1" {
  provider               = aws
  connection_termination = "false"
  deregistration_delay   = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "2"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = "10"
    unhealthy_threshold = "2"
  }

  name               = "tg-capterra-mainsite-prd-ue1"
  port               = "443"
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