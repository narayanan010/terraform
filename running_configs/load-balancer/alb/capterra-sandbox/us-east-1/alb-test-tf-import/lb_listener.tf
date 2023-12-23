resource "aws_lb_listener" "frontend_http_tcp" {
  provider = aws
  default_action {
    target_group_arn = aws_lb_target_group.alb-test-tf-import-tg.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.alb-test-tf-import.arn
  port              = "80"
  protocol          = "HTTP"
}

resource "aws_lb_listener" "frontend_https" {
  provider = aws
  certificate_arn = "arn:aws:acm:us-east-1:944864126557:certificate/5b6b2384-664b-4dc8-b889-08c8ff1772b2"

  default_action {
    target_group_arn = aws_lb_target_group.alb-test-tf-import-tg2.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.alb-test-tf-import.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}
