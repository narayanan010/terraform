resource "null_resource" "recreation" {
  triggers = {
    sha256 = filebase64sha256("${path.module}/source/user_data.tftpl")
  }
}

resource "aws_launch_template" "launch_template" {
  name                   = "${local.services_name}-${var.tag_environment}"
  description            = "Launch template for application ${var.tag_application}"
  image_id               = data.aws_ami.default.id
  instance_type          = "t3.medium"
  update_default_version = true

  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized           = true

  vpc_security_group_ids               = [aws_security_group.security_group_ec2.id, aws_security_group.security_group_alb.id]
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      iops                  = 300
      delete_on_termination = true
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2 # value required bridge networking 
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = var.tag_monitoring
  }

  user_data = base64encode(templatefile("${path.module}/source/user_data.tftpl", { ecs_name = local.ecs_name }))

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [image_id]
  }

  depends_on = [null_resource.recreation]
}
