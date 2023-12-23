resource "aws_lb_listener" "listener-nlb-cap-mainsite-prod-ue1" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-capterra-mainsite-prd-ue1/59445ace8c861b5f"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.nlb-cap-mainsite-prod-ue1.arn
  port              = "443"
  protocol          = "TCP"
}