resource "aws_lb_target_group" "tg-ataccama-access" {
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

  name               = "tg-ataccama-access"
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
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  target_type = "instance"
  vpc_id      = "vpc-60714d06"
}