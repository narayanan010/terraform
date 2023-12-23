data "aws_caller_identity" "current" {}


locals {
  ecs_cluster_name = format("%s-%s-cluster-fargate", var.app, var.stage)
}

resource "aws_ecs_cluster" "this" {
  count = var.create_ecs ? 1 : 0
  name = local.ecs_cluster_name
  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    iterator = strategy

    content {
      capacity_provider = strategy.value["capacity_provider"]
      weight            = lookup(strategy.value, "weight", null)
      base              = lookup(strategy.value, "base", null)
    }
  }

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  tags = merge({ "Name" = local.ecs_cluster_name }, var.tags)
}