resource "aws_lb_listener" "mainsite-alb-staging-ue1-http-listener" {
  provider           = aws
  default_action {
    order            = "1"
    redirect {
      host           = "#{host}"
      path           = "/#{path}"
      port           = "443"
      protocol       = "HTTPS"
      query          = "#{query}"
      status_code    = "HTTP_301"
    }

    type             = "redirect"
  }

  load_balancer_arn  = aws_lb.mainsite-alb-staging-ue1.arn
  port               = "80"
  protocol           = "HTTP"
}

resource "aws_lb_listener" "mainsite-alb-staging-ue1-https-listener" {
  provider           = aws
  certificate_arn    = "arn:aws:acm:us-east-1:176540105868:certificate/3ef8a4cd-b4cf-482e-bb70-2c313a7c63fc"

  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/mainsite-staging-tg-ue1/51ab539b1118b0ce"
    type             = "forward"
  }

  load_balancer_arn  = aws_lb.mainsite-alb-staging-ue1.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}