resource "aws_alb" "api_bluegreen" {
  name = "${var.tag_application}-bluegreen"

  security_groups    = [aws_security_group.security_group_alb.id]
  load_balancer_type = "application"

  subnets = ["subnet-04b6c320a96ff9dad", "subnet-0f909ae0fd58067f4"] ## CHECK IT

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
      tags_all
    ]
  }

}

# ALB Listeners
resource "aws_lb_listener" "blue" {
  load_balancer_arn = aws_alb.api_bluegreen.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    ignore_changes = [default_action[0].target_group_arn]
  }

  depends_on = [aws_lb_target_group.blue]
}

resource "aws_lb_listener" "blue_https" {
  load_balancer_arn = aws_alb.api_bluegreen.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_lb_target_group.blue.arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action[0].target_group_arn]
  }

  depends_on = [aws_lb_target_group.blue, aws_acm_certificate_validation.certvalidation]
}


# Target Groups
resource "aws_lb_target_group" "blue" {
  name             = "${var.tag_application}-blue"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/health"
    protocol = "HTTP"
  }

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }

  depends_on = [aws_alb.api_bluegreen]
}

resource "aws_lb_target_group" "green" {
  name             = "${var.tag_application}-green"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/health"
    protocol = "HTTP"
  }
  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }

  depends_on = [aws_alb.api_bluegreen]
}
