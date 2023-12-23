resource "aws_lb_listener" "listener-atacama-oracle-access" {
  provider        = aws
  alpn_policy     = "HTTP2Preferred"
  certificate_arn = "arn:aws:acm:us-east-1:176540105868:certificate/3ef8a4cd-b4cf-482e-bb70-2c313a7c63fc"

  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-ataccama-access/2c9b641bb51c0689"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.atacama-oracle-access.arn
  port              = "1521"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}