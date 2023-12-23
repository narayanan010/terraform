resource "aws_lb" "cap_elb_snowflake_prod" {


  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
  internal                         = true
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "cap-elb-snowflake-prod"

  subnet_mapping {
    subnet_id = "subnet-87666faa"
  }

  subnet_mapping {
    subnet_id = "subnet-1529d05d"
  }

  subnet_mapping {
    subnet_id = "subnet-0691e5d3a1bb015d1"
  }

  #subnets = ["subnet-0691e5d3a1bb015d1", "subnet-1529d05d", "subnet-87666faa"]

  tags = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }
}

resource "aws_lb_target_group" "tg_snowflake_prod" {
  health_check {
    enabled             = true
    healthy_threshold   = "3"
    interval            = "30"
    port                = "traffic-port"
    protocol            = "TCP"
    unhealthy_threshold = "3"
  }

  name              = "TG-snowflake-prod"
  port              = "22"
  protocol          = "TCP"
  proxy_protocol_v2 = false
  tags = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }
  target_type       = "instance"
  vpc_id            = "vpc-c2ecc1a4"
}



resource "aws_lb_target_group_attachment" "snowflake_prod_tg_attach_e1a" {
  target_group_arn = "${aws_lb_target_group.tg_snowflake_prod.arn}"
  target_id        = "i-0f481f65916afcb8f"
  port = 22
}

resource "aws_lb_target_group_attachment" "snowflake_prod_tg_attach_e1b" {
  target_group_arn = "${aws_lb_target_group.tg_snowflake_prod.arn}"
  target_id        = "i-01d8e4a627bb169ad"
  port = 22
}

resource "aws_lb_listener" "snowflake_ssh_listener" {
  load_balancer_arn = "${aws_lb.cap_elb_snowflake_prod.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.tg_snowflake_prod.arn}"
  }
}

