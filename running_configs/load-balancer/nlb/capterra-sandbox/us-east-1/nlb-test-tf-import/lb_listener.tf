resource "aws_lb_listener" "frontend_http_tcp" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:944864126557:targetgroup/nlb-test-tf-import-tg/eb10bd8ab8279a82"
    type             = "forward"
  }

  load_balancer_arn  = aws_lb.nlb-test-tf-import.arn
  port               = "80"
  protocol           = "TCP"
}

resource "aws_lb_listener" "frontend_https" {
  provider           = aws
  certificate_arn    = "arn:aws:acm:us-east-1:944864126557:certificate/5b6b2384-664b-4dc8-b889-08c8ff1772b2"

  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:944864126557:targetgroup/nlb-test-tf-import-tg2/4541a2677cf082ad"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.nlb-test-tf-import.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}
