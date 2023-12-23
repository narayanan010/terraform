module "aws_lb_module" {

  source = "../../../../../../../modules/load-balancer/alb/"

  ec2_subnets = ["subnet-0c5e8f668aa775abb", "subnet-0b9fc362ba93bc18f", "subnet-0a0f257aa7c7a10f5"]

  alb_sg_name = "mainsite_alb_prod_dr_sg"

  alb_name = "mainsite-alb-prod-dr-uw2"

  vpc_id = "vpc-01dd95434aa80f7a8"

  waf_acl = true

  waf_acl_name = "mainsite-acl-prod-us-west-2"

  waf_acl_scope = "REGIONAL"

  acm_data_block = true

  acm_domain = "*.capterra.com"

  enable_deletion_protection = true

  enable_waf_fail_open = true

  sg_ingress_rules_cidr = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "Allow global ingress on Port 80" },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = [], ipv6_cidr_blocks = ["::/0"], description = "Allow global ingress on Port 80" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "Allow global ingress on Port 443" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = [], ipv6_cidr_blocks = ["::/0"], description = "Allow global ingress on Port 443" }
  ]

  create_sg_ingress_source_sg = false

  sg_egress_rules_cidr = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "Allow egress on all ports" }
  ]

  internal = false

  lb_logs = {
    bucket  = "capterra-loadbalancer-dr-logs"
    enabled = true
    prefix  = "mainsite-alb-prod-dr-uw2"
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
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTPS"
        matcher             = "200,301"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id         = "i-01da684b41f60a0f6"
          port              = 443
        },
        my_ec2_again = {
          target_id         = "i-03dfa921f7cb2569c"
          port              = 443
        }
      }
    }
  ]

  providers = {
    aws = aws
  }
}