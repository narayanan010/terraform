resource "aws_lb_listener" "listener_snowflake-prod" {
  provider           = aws
  default_action {
    order            = "1"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/TG-snowflake-prod/713550532279a776"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-snowflake-prod.arn
  port              = "22"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener_or5-prod" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-or5-prod/712a2382a3c3214f"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-snowflake-prod.arn
  port              = "31523"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener_edg2-prod-equinix" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-edg2-prod-equinix/b235db36d5d66842"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-snowflake-prod.arn
  port              = "31522"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener_edg1-prod-equinix" {
  provider           = aws
  default_action {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:176540105868:targetgroup/tg-edg1-prod-equinix/defc030892712ca3"
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-snowflake-prod.arn
  port              = "31521"
  protocol          = "TCP"
}

resource "aws_lb_listener" "listener_or5dg2-prod" {
  provider           = aws
  default_action {
    target_group_arn = aws_lb_target_group.tg-or5dg2-prod.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.cap-elb-snowflake-prod.arn
  port              = "31524"
  protocol          = "TCP"
}