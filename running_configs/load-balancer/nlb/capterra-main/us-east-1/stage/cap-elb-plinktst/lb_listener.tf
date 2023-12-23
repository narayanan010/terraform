resource "aws_lb_listener" "listener-np1-equinix" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-np1-equinix/35183b50ea261e53"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-plinktst.arn
  port              = "31521"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener-astg2" {
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-astg2/f93f4e2079949918"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-plinktst.arn
  port              = "31522"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener-astg3" {
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-astg3/0d81255660c0d40b"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-plinktst.arn
  port              = "31523"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener-astg7" {
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-astg7/2c98467a2711a831"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-plinktst.arn
  port              = "31527"
  protocol          = "TCP"
}
