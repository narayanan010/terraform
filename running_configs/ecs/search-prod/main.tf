

locals {
  services_name = "ecs-${var.tag_application}"
  ecs_name      = lower("${var.tag_application}-${var.tag_environment}")
  ecs_task      = "api_bluegreen"
}


resource "aws_cloudwatch_log_group" "ecs_cluster" {
  name              = "/aws/ecs/${local.ecs_name}"
  retention_in_days = var.cw_logs_retention
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.ecs_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  configuration {
    execute_command_configuration {
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster.name
      }
      logging = "OVERRIDE"
    }
  }
}
