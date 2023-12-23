resource "aws_lb_listener" "NLB-steam-udp-lsnr" {
  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/TG-steam-FWKNOP/4123e627ce580278"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.NLB-steam.arn
  port              = "62201"
  protocol          = "UDP"
}

resource "aws_lb_listener" "NLB-steam-tcp-lsnr" {
  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/TG-steam-SSH/40ce2df35ae505ce"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.NLB-steam.arn
  port              = "22"
  protocol          = "TCP"
}