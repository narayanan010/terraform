# Type: Amazon ECS Compute Platform
resource "aws_codedeploy_app" "api_bluegreen_ecs" {
  compute_platform = "ECS"
  name             = "user-workspace-${var.tag_environment}"
}

resource "aws_codedeploy_deployment_group" "api_bluegreen_ecs" {
  app_name               = aws_codedeploy_app.api_bluegreen_ecs.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "user-workspace-${var.tag_environment}"
  service_role_arn       = var.modulecaller_assume_role_ecs_deployer

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    service_name = aws_ecs_service.api_bluegreen_ec2.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.blue_https.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_codedeploy_app.api_bluegreen_ecs]
}
