locals {
  ec2_suffix = ["1"]
}

module "datadog-instance" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/ec2_v2"

  for_each            = toset(local.ec2_suffix)
  ec2_count           = each.key
  stage               = var.stage
  technology          = var.application
  ec2_security_groups = ["sg-06a8b5b3107c86187"] # recreate a new one
  ec2_instance_type   = "t2.small"
  ec2_key_name        = "capterra-search-staging-key-ue1"
  ec2_ami             = "ami-02eac2c0129f6376b"
  ec2_subnets         = "subnet-0272efa24d4855bfb"

  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    },
  ]

  tags = merge(module.tags_resource_module.tags, { backup-dlm = "staging" })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "IAMRole_DataDog"
  role = "DataDogKafkaMonitoringStage"
}
