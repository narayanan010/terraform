resource "aws_instance" "tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment" {
  ami                         = "ami-01ed306a12b7d1c96"
  associate_public_ip_address = "false"
  cpu_core_count              = "2"
  cpu_threads_per_core        = "2"
  disable_api_termination     = "true"
  ebs_optimized               = "true"
  instance_type               = "m5.xlarge"
  key_name                    = "${var.ec2_key_name}"

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
  }

  monitoring = "true"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "300"
    volume_size           = "100"
    volume_type           = "gp2"
  }

  source_dest_check = "true"
  subnet_id         = "subnet-09777af13fed9be6e"

  tags = {
    APPLICATION    = "ADMIN"
    Backup         = "yes"
    BackupSchedule = "*"
    ENVIRONMENT    = "PROD-NON-CRITICAL"
    Name           = "Central Deployment DR"
    NoReboot       = "true"
    RetentionDays  = "10"
    terraform_managed = "true"
  }

  tenancy = "default"

  volume_tags = {
    ENVIRONMENT = "PROD-NON-CRITICAL"
  }

  vpc_security_group_ids = ["${aws_security_group.sg-cds.id}"]
}


resource "aws_security_group" "sg-cds" {
  name        = "SecurityGp-for-central-deployment-server"
  description = "Allow internal inbound traffic"
  vpc_id      = "vpc-01dd95434aa80f7a8"

  ingress {
    description = "Internal traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.114.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SecurityGp-for-central-deployment-server"
    terraform_managed = "true"
  }
}