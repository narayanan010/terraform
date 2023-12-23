resource "aws_lb_listener" "https_listener_mainsite_prod_b" {
  provider        = aws
  certificate_arn = "arn:aws:acm:us-east-1:176540105868:certificate/f94f7558-d37d-41c6-94dc-4bd5ee1e27c3"

  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-mainsite-prod-b/25074caa4f413e78"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.mainsite-alb-prod-us-east-1b.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

resource "aws_lb_listener" "http_listener_mainsite_prod_b" {
  provider = aws
  default_action {
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  load_balancer_arn = aws_lb.mainsite-alb-prod-us-east-1b.arn
  port              = "80"
  protocol          = "HTTP"
}
