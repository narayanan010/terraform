resource "aws_lb_target_group" "alb-test-tf-import-tg" {
  provider = aws
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "alb-test-tf-import-tg"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
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

resource "aws_lb_target_group" "alb-test-tf-import-tg2" {
  provider = aws
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "alb-test-tf-import-tg2"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
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
