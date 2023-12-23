module "aws_nlb_module" {

  source = "../../../../../../modules/load-balancer/nlb/"

  ec2_subnets = ["subnet-0c92174c89cf6d257", "subnet-31f2a81e"]

  nlb_name = "nlb-internal"

  acm_data_block = true

  acm_domain = "foobar.capstage.net"

  vpc_id = "vpc-fad17781"

  internal = true

  lb_logs = {
    bucket  = "capterra-loadbalancer-logs"
    enabled = true
    prefix  = "nlb-internal-sandbox"
  }

  create_pvt_link = true

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 81
      protocol           = "TCP"
      target_group_index = 1
    },
    {
      port               = 82
      protocol           = "TCP"
      target_group_index = 2
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      target_group_index = 3
      action_type        = "forward"
    }
  ]

  target_groups = [
    {
      name                 = "nlb-tg-1"
      backend_protocol     = "TCP"
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
        matcher             = "200-399"
      }
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
      name                 = "nlb-tg-2"
      backend_protocol     = "TCP"
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
        matcher             = "200-399"
      }
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
      name                 = "nlb-tg-3"
      backend_protocol     = "TCP"
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
        matcher             = "200-399"
      }
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
      name                 = "nlb-tg-4"
      backend_protocol     = "TLS"
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
        matcher             = "200-399"
      }
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
