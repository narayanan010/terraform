# Sevice Type: EC2
resource "aws_ecs_service" "api_bluegreen_ec2" {
  name            = "${local.ecs_name}-bridge"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.api_bluegreen.arn
  launch_type     = "EC2"

  desired_count           = 2
  enable_ecs_managed_tags = true
  force_new_deployment    = false
  scheduling_strategy     = "REPLICA"
  wait_for_steady_state   = false

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_listener.blue_https.default_action[0].target_group_arn
    container_name   = local.ecs_task
    container_port   = 80
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancer, task_definition, desired_count]
  }

  depends_on = [aws_lb_listener.blue_https]
}

resource "aws_ecs_task_definition" "api_bluegreen" {
  family                   = "api_bluegreen"
  cpu                      = 512
  memory                   = 256
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_task.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = <<TASK_DEFINITION
    [
        {
        "name": "api_bluegreen",
        "image": "first",
        "cpu": 512,
        "dnsSearchDomains": [],
        "environmentFiles": null,
        "entryPoint": [],
        "portMappings": [
            {
            "containerPort": 80,
            "hostPort": 0
            }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "volumes": [],
        "essential": true
        }
    ]
    TASK_DEFINITION

  lifecycle {
    ignore_changes = all
  }
}
