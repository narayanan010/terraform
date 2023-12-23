
locals {
  ecs_task      = "api_bluegreen"
  task_name     = "api_bluegreen"
}

resource "aws_ecs_task_definition" "api_bluegreen" {
  family                   = local.ecs_task
  cpu                      = 512
  memory                   = var.task_memory[terraform.workspace]
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = data.terraform_remote_state.common_resources.outputs.ecs_task_arn
  task_role_arn             = var.modulecaller_assume_role_ecs_deployer[terraform.workspace]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = <<TASK_DEFINITION
    [
        {
        "name": "${local.ecs_task}",
        "image": "${var.ecr_image_uri}",
        "cpu": 512,
        "memoryReservation": ${var.task_memory[terraform.workspace]},
        "dnsSearchDomains": [],
        "environmentFiles": null,
        "entryPoint": [],
        "portMappings": [
            {
            "name": "${local.ecs_task}",
            "containerPort": 80,
            "hostPort": 0,
            "protocol": "tcp",
            "appProtocol": "http"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
              "awslogs-group": "/aws/ecs/${var.tag_application}-${terraform.workspace}/task/${local.task_name}",
              "awslogs-region": "${var.modulecaller_source_region}",
              "awslogs-create-group": "true",
              "awslogs-stream-prefix": "container"
            }
        },
        "healthCheck": {
            "command": [
                "CMD-SHELL",
                "curl -f http://localhost:$PORT/health || 1"
            ],
            "interval": 30,
            "timeout": 5,
            "retries": 3
        },
        "mountPoints": [],
        "volumesFrom": [],
        "volumes": [],
        "essential": true,
        "environment": ${data.template_file.env_vars.rendered},
        "secrets": ${data.template_file.env_secrets.rendered}
        }
    ]
    TASK_DEFINITION
    
    lifecycle {
      ignore_changes = [tags,tags_all]
    }

    depends_on = [data.template_file.env_vars,data.template_file.env_secrets,aws_cloudwatch_log_group.api_bluegreen]
}


# Recreate resources if hash changed
resource "null_resource" "recreate_env_dev" {
  triggers = {
    sha256 = file(var.ecs_task_environment_file)
  }
}

data "template_file" "env_vars" {
  template = file(var.ecs_task_environment_file)
  depends_on = [null_resource.recreate_env_dev]
}

# Recreate resources if hash changed
resource "null_resource" "recreate_secrets_dev" {
  triggers = {
    sha256 = file(var.ecs_task_secrets_file)
  }
}

data "template_file" "env_secrets" {
  template = file(var.ecs_task_secrets_file)
  depends_on = [null_resource.recreate_secrets_dev]
}


resource "aws_cloudwatch_log_group" "api_bluegreen" {
  name              = "/aws/ecs/${var.tag_application}-${terraform.workspace}/task/${local.task_name}"
  retention_in_days = var.cw_logs_retention[terraform.workspace]
}

# Kinesis Log subscription
resource "aws_cloudwatch_log_subscription_filter" "api_bluegreen" {
  name            = "DatadogCapterra_KinesisStream"
  role_arn        = data.terraform_remote_state.common_resources.outputs.kinesis_role_arn
  log_group_name  = aws_cloudwatch_log_group.api_bluegreen.id
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.common_resources.outputs.kinesis_firehose_arn
  distribution    = "ByLogStream"

  depends_on = [aws_cloudwatch_log_group.api_bluegreen]
}
