terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"     
  }
  
}

data "aws_ami" "centos7_hvm_ebs_64" {
    owners = ["679593333241"]
    most_recent = true
    filter {
        name = "name"
        values = ["CentOS Linux 7 x86_64 HVM EBS *"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
}

resource "aws_ebs_volume" "capterra-scripts-vol" {
    #availability_zone = "${module.gdm-task-scheduler.availability_zone}"
    availability_zone = "us-east-1a"
    type = "gp2"
    size = "200"
    tags {
        Name = "Task Scheduler Scripts Volume"
        stage = "prd"
        terraform = "true"        
    }
}

resource "aws_ebs_volume" "capterra-logs-vol" {
    #availability_zone = "${module.gdm-task-scheduler.availability_zone}"
    availability_zone = "us-east-1a"
    type = "gp2"
    size = "100"
        tags {
        Name = "Task Scheduler Logs Volume"
        stage = "prd"
        terraform = "true"        
    }
}

module "gdm-task-scheduler" {
    source = "../../modules/ec2"
    ec2_count = "1"
    stage = "prd"
    platform = ""
    technology = "sched"
    vertical = "cap"
    ec2_security_groups = ["sg-0a630675"]
    ec2_instance_type = "m5.xlarge"
    ec2_key_name = "prod-us-east-1-capterra-general-purpose-key"
    ec2_ami = "${data.aws_ami.centos7_hvm_ebs_64.image_id}"
    ec2_aws_region = "us-east-1"
    ec2_subnets = ["subnet-3d3e2910", "subnet-3d3e2910"]
}

resource "aws_volume_attachment" "capterra-scripts-attach" {
    device_name = "/dev/sdh"
    volume_id = "${aws_ebs_volume.capterra-scripts-vol.id}"
    instance_id = "${module.gdm-task-scheduler.id[0]}"
    depends_on = ["aws_ebs_volume.capterra-scripts-vol"]
}

resource "aws_volume_attachment" "capterra-logs-attach" {
    device_name = "/dev/sdi"
    volume_id = "${aws_ebs_volume.capterra-logs-vol.id}"
    instance_id = "${module.gdm-task-scheduler.id[0]}"
    depends_on = ["aws_ebs_volume.capterra-logs-vol"]
}