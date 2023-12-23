module "aws_lb_module" {

  source = "../../../../../../../modules/load-balancer/alb/"
  #source = "git::ssh://git@github.com/capterra/terraform.git//modules/load-balancer/alb/"

  ec2_subnets = ["subnet-f2736edf", "subnet-6514d82d", "subnet-05de4875508632d63"]

  alb_sg_name = "alb-cap-mainsite-staging-sg"

  alb_name = "alb-cap-mainsite-staging-ue1"

  vpc_id = "vpc-60714d06"

  enable_deletion_protection = true

  enable_cross_zone_load_balancing = true

  waf_acl = true

  waf_acl_name = "mainsite-acl-staging-ue1"

  waf_acl_scope = "REGIONAL"

  acm_data_block = true

  acm_domain = "*.capstage.net"

  sg_ingress_rules_cidr = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "Allow global ingress on Port 80" },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = [], ipv6_cidr_blocks = ["::/0"], description = "Allow global ingress on Port 80" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "Allow global ingress on Port 443" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = [], ipv6_cidr_blocks = ["::/0"], description = "Allow global ingress on Port 443" }
  ]

  create_sg_ingress_source_sg = false

  sg_egress_rules_cidr = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "" }
  ]

  internal = false

  lb_logs = {
    bucket  = "capterra-loadbalancer-logs"
    enabled = true
    prefix  = "alb-cap-mainsite-staging-ue1"
  }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
      action_type        = "forward"
      ssl_policy         = "ELBSecurityPolicy-TLS13-1-0-2021-06"
    }
  ]

  target_groups = [
    {
      name                 = "alb-tg-1"
      backend_protocol     = "HTTPS"
      backend_port         = 443
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/nginx_status"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTPS"
        matcher             = "200-399,403"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id         = "i-088d6e3b7179d5f72"
          port              = 443
        },
        my_ec2_again = {
          target_id         = "i-05cbe446e2c0f5a5d"
          port              = 443
        }
      }
    }
  ]

  providers = {
    aws = aws
  }
}