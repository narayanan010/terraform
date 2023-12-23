module "aws_lb_module" {

  source = "../../../../../../modules/load-balancer/alb/"

  ec2_subnets = ["subnet-0dd5a03df7503339e", "subnet-0a858b69e3f39ac5c"]

  alb_sg_name = "alb_sg"

  alb_name = "alb-sandbox"

  vpc_id = "vpc-07ba6aa30f9e27595"

  waf_acl = true

  waf_acl_name = "FMManagedWebACLV2-AWS_FMS_ShieldAdvancedRule-1655501154300"

  waf_acl_scope = "REGIONAL"

  acm_data_block = true

  acm_domain = "foobar.capstage.net"

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
    prefix  = "alb-sandbox"
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
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # targets = {
      #   my_ec2 = {
      #     target_id         = ""
      #     availability_zone = "us-east-1a"
      #     port              = 80
      #   },
      #   my_ec2_again = {
      #     target_id         = ""
      #     availability_zone = "us-east-1b"
      #     port              = 80
      #   }
      # }
    }
  ]

  providers = {
    aws = aws
  }
}