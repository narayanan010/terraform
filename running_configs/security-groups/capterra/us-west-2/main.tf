module "aws_sec_grp_module" {
  source                      = "../../../../modules/security-groups/"
  create_sg                   = true
  create_sg_ingress_cidr      = false
  create_sg_egress_cidr       = true
  sec_grp_names               = [
    { name                    = "Remote-DR-Bastion-Access-Dev-VPC_IngressAddedByJenkins"
      vpc_id                  = "vpc-01dd95434aa80f7a8"
      description             = "Test Security Group 1 for Sandbox" 
    }
  ]

  sg_egress_rules_cidr        = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "" }
  ]
  providers = {
    aws = aws
  }
}