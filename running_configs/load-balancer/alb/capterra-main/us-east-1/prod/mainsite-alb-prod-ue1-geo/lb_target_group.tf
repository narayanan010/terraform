resource "aws_lb_target_group" "tg-mainsite-prod-geo-us-east-1" {
  provider             = aws
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200,301"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "tg-mainsite-prod-geo-us-east-1"
  port                          = "443"
  protocol                      = "HTTPS"
  protocol_version              = "HTTP2"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
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
  vpc_id      = "vpc-c2ecc1a4"
}
