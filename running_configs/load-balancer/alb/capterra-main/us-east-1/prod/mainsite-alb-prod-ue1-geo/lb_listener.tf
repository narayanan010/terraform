resource "aws_lb_listener" "listener-mainsite-alb-prod-ue1-geo" {
  provider        = aws
  certificate_arn = "arn:aws:acm:us-east-1:176540105868:certificate/f94f7558-d37d-41c6-94dc-4bd5ee1e27c3"

  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-mainsite-prod-geo-us-east-1/a2b1f921268c290a"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.mainsite-alb-prod-ue1-geo.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}
