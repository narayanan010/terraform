data "aws_availability_zones" "available" {}

locals {
  ec2_suffix = ["1"]
}

module "deployment_server" {
  source = "git::https://github.com/capterra/terraform.git//modules/ec2_v2"

  for_each            = toset(local.ec2_suffix)
  ec2_count           = each.key
  stage               = var.stage
  technology          = var.application
  ec2_security_groups = var.ec2_security_groups
  ec2_instance_type   = var.ec2_instance_type
  ec2_key_name        = var.ec2_key_name
  ec2_ami             = var.ec2_ami
  ec2_subnets         = var.ec2_subnets
  ec2_AZ              = data.aws_availability_zones.available.names[0]

  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.instance_SSM_profile.name

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 40
    },
  ]
}