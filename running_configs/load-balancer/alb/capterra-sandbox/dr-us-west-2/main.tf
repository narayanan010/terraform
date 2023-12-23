module "aws_lb_module" {

  source = "../../../../../modules/load-balancer/alb/"

  ec2_subnets = ["subnet-0c92174c89cf6d257", "subnet-31f2a81e"]

  alb_sg_name = "alb_sg"

  alb_name = "alb-internal-sandbox"

  vpc_id = "vpc-fad17781"

  waf_acl = true

  waf_acl_name = "FMManagedWebACLV2-AWS_FMS_ShieldAdvancedRule-1655501154300"

  waf_acl_scope = "REGIONAL"

  acm_data_block = true

  acm_domain = "foobar.capstage.net"

  sg_ingress_rules_cidr = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 81, to_port = 81, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 82, to_port = 82, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" }
  ]

  create_sg_ingress_source_sg = true

  sg_ingress_rules_source_sg = [
    { from_port = 8080, to_port = 8080, protocol = "tcp", source_sg_id = "sg-0d84e013f4d2b5d2e", description = "" }
  ]

  sg_egress_rules_cidr = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "" }
  ]

  internal = true

  lb_logs = {
    bucket  = "capterra-loadbalancer-logs"
    enabled = true
    prefix  = "nlb-internal-sandbox"
  }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 81
      protocol           = "HTTP"
      target_group_index = 1
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
    {
      port               = 82
      protocol           = "HTTP"
      target_group_index = 2
      action_type        = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "200"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 3
      action_type        = "forward"

    }
  ]

  target_groups = [
    {
      name                 = "alb-tg-1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.174"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.24"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-2"
      backend_protocol     = "HTTP"
      backend_port         = 81
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.172"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.22"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-3"
      backend_protocol     = "HTTP"
      backend_port         = 82
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index2.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.176"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.26"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-4"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index3.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.178"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.28"
          availability_zone = "all"
          port              = 8080
        }
      }
    }
  ]

  providers = {
    aws = aws
  }
}