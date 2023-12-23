data "template_file" "hostname" {
  template = file("${path.module}/init/hostname.sh")
}

data "template_cloudinit_config" "capterra-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.hostname.rendered
  }
}

resource "aws_instance" "this" {

  count                  = var.create ? 1 : 0
  user_data              = data.template_cloudinit_config.capterra-cloudinit.rendered
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  availability_zone      = var.ec2_AZ
  key_name               = var.ec2_key_name
  vpc_security_group_ids = var.ec2_security_groups
  subnet_id              = var.ec2_subnets

  monitoring           = var.monitoring
  iam_instance_profile = var.iam_instance_profile

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  tags = merge({ "Name" = "${var.technology}-${var.stage}-${var.ec2_count}" }, var.tags)
}