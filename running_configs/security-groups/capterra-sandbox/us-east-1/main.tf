module "aws_sec_grp_module" {
  source                      = "../../../../modules/security-groups/"
  create_sg                   = true
  create_sg_ingress_cidr      = true
  create_sg_egress_cidr       = true
  sec_grp_names               = [
    { name                    = "test-sec-grp-1"
      vpc_id                  = "vpc-fad17781"
      description             = "Test Security Group 1 for Sandbox" 
    }
  ]
  sg_ingress_rules_cidr       = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 81, to_port = 81, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 82, to_port = 82, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" }
  ]
  sg_egress_rules_cidr        = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "" }
  ]
  providers = {
    aws = aws
  }
}

data aws_security_group "module1_sg" {
  name                        = "test-sec-grp-1"
  vpc_id                      = "vpc-fad17781"
  depends_on = [
    module.aws_sec_grp_module
  ]
}

module "aws_sec_grp2_module" {
  source                      = "../../../../modules/security-groups/"
  create_sg                   = true
  create_sg_ingress_source_sg = true
  create_sg_egress_source_sg  = true
  sec_grp_names               = [
    { name = "test-sec-grp-2"
      vpc_id = "vpc-fad17781"
      description = "Test Security Group 2 for Sandbox" 
    }
  ]
  sg_ingress_rules_source_sg  = [
    { from_port = 80, to_port = 80, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 81, to_port = 81, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 82, to_port = 82, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 443, to_port = 443, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" }
  ]
  sg_egress_rules_source_sg   = [
    { from_port = 0, to_port = 0, protocol = "-1", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" }
  ]
  providers = {
    aws = aws
  }
  depends_on = [
    module.aws_sec_grp_module
  ]
}