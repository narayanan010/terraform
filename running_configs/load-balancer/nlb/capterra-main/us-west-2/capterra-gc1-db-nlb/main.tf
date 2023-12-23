module "aws_nlb_module" {
  source = "../../../../../../modules/load-balancer/nlb/"
  ec2_subnets = ["subnet-09777af13fed9be6e", "subnet-03c6c67c42e458e6a", "subnet-02393287a7560bdd9"]
  nlb_name = "capterra-gc1-db-nlb"
  #acm_data_block = true
  #acm_domain = "foobar.capstage.net"
  vpc_id = "vpc-01dd95434aa80f7a8"
  internal = true
  lb_logs = {
    bucket  = "capterra-loadbalancer-logs"
    enabled = true
    prefix  = "capterra-gc1-db-nlb-uw2"
  }
  create_pvt_link = false
  
  stage           = "prod-dr"
  vertical        = "capterra"

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 31521
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 31522
      protocol           = "TCP"
      target_group_index = 1
    },
    {
      port               = 31523
      protocol           = "TCP"
      target_group_index = 2
    }
  ]

  #https_listeners = [
    #{
      #port               = 443
      #protocol           = "TLS"
      #target_group_index = 3
      #action_type        = "forward"
    #}
  #]

  target_groups = [
    {
      name                 = "tg-edg1-prod-equinix"
      backend_protocol     = "TCP"
      backend_port         = 1521
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        protocol            = "TCP"
        enabled             = true
        interval            = 30
        #path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
        #matcher             = "200-399"
      }
      targets = {
        my_ec2 = {
          target_id = "10.114.7.18"
          port      = 1521
          availability_zone = "all"
        }
      }
    },
    {
      name                 = "tg-edg2-prod-equinix"
      backend_protocol     = "TCP"
      backend_port         = 1521
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        protocol            = "TCP"      
        enabled             = true
        interval            = 30
        #path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
        #matcher             = "200-399"
      }
      targets = {
        my_ec2 = {
          target_id = "10.114.7.19"
          port      = 1521
          availability_zone = "all"
        }
      }
    },
    {
      name                 = "tg-or5-prod-dr"
      backend_protocol     = "TCP"
      backend_port         = 1521
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        protocol            = "TCP"      
        enabled             = true
        interval            = 30
        #path                = "/index2.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        #timeout             = 6
        #matcher             = "200-399"
      }
      targets = {
        my_ec2 = {
          target_id = "i-0f306ab2dfe112f82"
          port      = 1521
        }
      }
    }
  ]
}
