locals {
  task_name = "datadog-agent"
}

resource "aws_ecs_task_definition" "datadog_agent" {
  family                   = "datadog-agent"
  cpu                      = 128
  memory                   = 256
  requires_compatibilities = ["EC2", "EXTERNAL"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_task.arn
  task_role_arn            = var.modulecaller_assume_role_ecs_deployer
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }
  volume {
    name      = "proc"
    host_path = "/proc/"
  }
  volume {
    name      = "cgroup"
    host_path = "/sys/fs/cgroup/"
  }
  volume {
    name      = "debug"
    host_path = "/sys/kernel/debug"
  }
  container_definitions = <<TASK_DEFINITION
    [
        {
            "name": "datadog-agent",
            "image": "public.ecr.aws/datadog/agent:latest",
            "cpu": 128,
            "memory": 256,
            "portMappings": [
              {
                  "containerPort": 8125,
                  "hostPort": 0,
                  "protocol": "udp"
              }
            ],
            "essential": true,
            "linuxParameters": {
                "capabilities": {
                    "add": [
                        "SYS_ADMIN",
                        "SYS_RESOURCE",
                        "SYS_PTRACE",
                        "NET_ADMIN",
                        "NET_BROADCAST",
                        "NET_RAW",
                        "IPC_LOCK",
                        "CHOWN"
                    ]
                }
            },
            "mountPoints": [
                {
                    "sourceVolume": "docker_sock",
                    "containerPath": "/var/run/docker.sock",
                    "readOnly": true
                },
                {
                    "sourceVolume": "cgroup",
                    "containerPath": "/host/sys/fs/cgroup",
                    "readOnly": true
                },
                {
                    "sourceVolume": "proc",
                    "containerPath": "/host/proc",
                    "readOnly": true
                },
                {
                    "sourceVolume": "debug",
                    "containerPath": "/sys/kernel/debug",
                    "readOnly": true
                }
            ],
            "volumesFrom": [],
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "agent health"
                ],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 15
            },
            "environment": ${data.template_file.env_devops.rendered},
            "secrets": ${data.template_file.secrets_devops.rendered}
        }
    ]
    TASK_DEFINITION
}

data "template_file" "env_devops" {
  template = file("${path.module}/source/.env_devops")
}

data "template_file" "secrets_devops" {
  template = file("${path.module}/source/.secrets_devops")
}


# Sevice Type: EC2
resource "aws_ecs_service" "devops" {
  name            = "devops"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.datadog_agent.arn
  launch_type     = "EC2"

  desired_count           = 2
  enable_ecs_managed_tags = true
  force_new_deployment    = false
  scheduling_strategy     = "REPLICA"
  wait_for_steady_state   = false

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [task_definition, desired_count]
  }

  depends_on = [aws_ecs_task_definition.datadog_agent]
}

resource "aws_cloudwatch_log_group" "datadog_agent" {
  name              = "/aws/ecs/${var.tag_application}-${var.tag_app_environment}/task/${local.task_name}"
  retention_in_days = var.cw_logs_retention
}