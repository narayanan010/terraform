resource "aws_lb_target_group" "mainsite-staging-tg-ue1" {
  provider                      = aws
  deregistration_delay          = "300"

  health_check {
    enabled                     = "true"
    healthy_threshold           = "5"
    interval                    = "30"
    matcher                     = "200,401,301"
    path                        = "/"
    port                        = "traffic-port"
    protocol                    = "HTTPS"
    timeout                     = "5"
    unhealthy_threshold         = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "mainsite-staging-tg-ue1"
  port                          = "443"
  protocol                      = "HTTPS"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration             = "86400"
    enabled                     = "false"
    type                        = "lb_cookie"
  }

  target_type                   = "instance"
  vpc_id                        = "vpc-60714d06"
}