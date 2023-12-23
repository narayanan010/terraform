data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }

  most_recent = true
  owners      = ["amazon"]
}

resource "aws_autoscaling_group" "autoscaling_group" {
  desired_capacity  = var.asg_desired_capacity
  health_check_type = "EC2"

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  max_size = 6
  min_size = 2
  name     = "${local.services_name}-${var.tag_environment}-asg"

  tag {
    key                 = "ecs_cluster"
    propagate_at_launch = true
    value               = local.ecs_name
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${local.services_name}-${var.tag_environment}"
  }

  tag {
    key                 = "TemplateVersion"
    propagate_at_launch = true
    value               = aws_launch_template.launch_template.latest_version
  }

  dynamic "tag" {
    for_each = module.tags_resource_module.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = ["subnet-08c97978fc2a3bb22", "subnet-08d7b79de2088d815"]

  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity"
  ]
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tag, desired_capacity]
  }

  depends_on = [aws_launch_template.launch_template]
}

data "aws_instances" "api_bluegreen" {
  instance_tags = {
    Name = local.ecs_name
  }

  instance_state_names = ["running"]
}

# Autoscaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 6
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.api_bluegreen_ec2.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# By EC2 CPU
resource "aws_autoscaling_policy" "asg_policy01" {
  name                      = "autoscaling-cpu-ec2-policy"
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0
  }

  lifecycle {
    ignore_changes = [adjustment_type]
  }
}

# By ECS Task Memory
resource "aws_appautoscaling_policy" "asg_policy02" {
  name               = "autoscaling-cpu-ecs-task-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 75
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "asg_policy022" {
  name               = "application-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 75
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

# By ECS Cluster CPU Reservation
resource "aws_autoscaling_policy" "asg_policy03" {
  name                      = "autoscaling-cpu-ecs-reservation-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  estimated_instance_warmup = 60

  target_tracking_configuration {
    target_value = 75
    customized_metric_specification {
      metrics {
        label = "Get CPU Reservation from ECS cluster"
        id    = "m1"
        metric_stat {
          metric {
            namespace   = "AWS/ECS"
            metric_name = "CPUReservation"
            dimensions {
              name  = "ClusterName"
              value = local.ecs_name
            }
          }
          stat = "Average"
        }
        return_data = true
      }
    }
  }
  depends_on = [aws_ecs_cluster.ecs_cluster]
}

# By ECS Cluster Memory Reservation
resource "aws_autoscaling_policy" "asg_policy04" {
  name                      = "autoscaling-memory-ecs-reservation-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  estimated_instance_warmup = 60

  target_tracking_configuration {
    target_value = 75
    customized_metric_specification {
      metrics {
        label = "Get Memory Reservation from ECS cluster"
        id    = "m2"
        metric_stat {
          metric {
            namespace   = "AWS/ECS"
            metric_name = "MemoryReservation"
            dimensions {
              name  = "ClusterName"
              value = local.ecs_name
            }
          }
          stat = "Average"
        }
        return_data = true
      }
    }
  }
  depends_on = [aws_ecs_cluster.ecs_cluster]
}
