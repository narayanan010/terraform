# VPC
output "vpc_id" {
  value       = var.vpc_id
  description = "The VPC id"
}

output "vpc_arn" {
  value       = data.aws_vpc.vpc_resource.arn
  description = "The VPC arn"
}

# TARGET GROUP
output "target_group_blue" {
  value = concat([aws_lb_target_group.blue.arn], [aws_lb_target_group.blue.name], [aws_lb_target_group.blue.port])
}


output "target_group_green" {
  value = concat([aws_lb_target_group.green.arn], [aws_lb_target_group.green.name], [aws_lb_target_group.green.port])
}


# AUTOSCALING GROUP
output "autoscaling_launch_template" {
  value = aws_launch_template.launch_template.arn
}

output "autoscaling_group" {
  value       = aws_autoscaling_group.autoscaling_group.arn
  description = "The autoscaling group ID"
}

# EC2
output "ec2_ids" {
  value       = data.aws_instances.api_bluegreen.ids
  description = "EC2 images from Autoscaling Group"
}

# ALB
output "alb_api_bluegreen" {
  value       = concat([aws_alb.api_bluegreen.arn], [aws_alb.api_bluegreen.dns_name], [aws_alb.api_bluegreen.load_balancer_type])
  description = "Application Load Balancer for bluegreen deployment"
}

output "alb_api_bluegreen_arn" {
  value       = aws_alb.api_bluegreen.arn
  description = "Application Load Balancer ARN for bluegreen deployment"
}

output "alb_listener_blue" {
  value       = concat([aws_lb_listener.blue.arn], [aws_lb_listener.blue.protocol], [aws_lb_listener.blue.port])
  description = "Listener blue HTTP for staging ALB"
}

output "alb_listener_blue_https" {
  value       = concat([aws_lb_listener.blue_https.arn], [aws_lb_listener.blue_https.protocol], [aws_lb_listener.blue_https.port])
  description = "Listener blue HTTPS for staging ALB"
}

# ECS
output "ecs_cluster" {
  value       = aws_ecs_cluster.ecs_cluster.arn
  description = "ECS cluster data"
}

output "ecs_service_bluegreen" {
  value       = aws_ecs_service.api_bluegreen_ec2.id
  description = "ECS service for bluegreen deployment"
}

output "ecs_service_devops" {
  value       = aws_ecs_service.devops.id
  description = "ECS service for devops deployment"
}

output "aws_ecs_task_datadog" {
  value       = concat([aws_ecs_task_definition.datadog_agent.arn], [aws_ecs_task_definition.datadog_agent.revision])
  description = "ECS Task datadog"
}

output "codedeploy_deployment_group" {
  value       = concat([aws_codedeploy_deployment_group.api_bluegreen_ecs.arn], [aws_codedeploy_deployment_group.api_bluegreen_ecs.app_name])
  description = "CodeDeploy Deployment"
}


# S3 Bucket
output "bucket_arn" {
  value = aws_s3_bucket.codedeploy_bucket.arn
}

output "bucket_id" {
  value = aws_s3_bucket.codedeploy_bucket.id
}

# IAM 
output "github_deployer_role" {
  value       = var.modulecaller_assume_role_ecs_deployer
  description = "CodeDeploy Role for GitHub actions"
}

output "ecs_task_arn" {
  value       = aws_iam_role.ecs_task.arn
  description = "ECS Task role ARN for datadog-agent & bluegreen tasks"
}


# CloudWatch
output "cw_loggroup_api_bluegreen_logging" {
  value       = aws_cloudwatch_log_group.api_bluegreen_logging.name
  description = "CloudWatch loggin group name"
}

# CodeDeploy Application
output "codedeploy_api_bluegreen" {
  value       = aws_codedeploy_app.api_bluegreen_ecs
  description = "CloudWatch loggin group name"
}

# CodeDeploy Application
output "codedeploy_app_api_bluegreen" {
  value       = aws_codedeploy_app.api_bluegreen_ecs
  description = "CloudWatch loggin group name"
}

# CodeDeploy Deployment Group
output "codedeploy_dg_api_bluegreen_name" {
  value       = aws_codedeploy_deployment_group.api_bluegreen_ecs.app_name
  description = "CloudWatch loggin group name"
}

# Route53
output "website_healthcheck" {
  value       = "https://${aws_route53_record.websiteurl.name}/health"
  description = "Host record to validate healthcheck"
}

# Kinesis
output "kinesis_firehose_arn" {
  value       = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.arn
  description = "The ARN of the Kinesis Firehose Stream"
}

output "kinesis_role_arn" {
  value       = aws_iam_role.kinesis_stream.arn
  description = "Kinesis role ARN for Datadog stream integration"
}

# Datadog
output "datadog_log_group" {
  value       = "@aws.firehose.arn:\"${aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.arn}\""
  description = "DataDog log group query for Capterra domain"
}

# SNS
output "sns_topic_arn" {
  description = "SNS Topic ARN for Slack integration"
  value       = aws_sns_topic.sns_topic_ags.arn
}

output "sns_lambda_arn" {
  description = "Lambda ARN for Slack integration"
  value       = aws_lambda_function.sns_lambda.arn
}

# SSM
output "ssm_slack_token_arn" {
  description = "ARN of the SSM Parameter for Slack token"
  value       = aws_ssm_parameter.slack_notify_token.arn
}

# Parameter Store
output "parameter_store_reminder" {
  description = "Remember manually modify System Manager parameter store value"
  value       = aws_ssm_parameter.slack_notify_token.id
}

# Secrets Manager
output "secrets_manager_uw" {
  description = "Secrets Manager for UW"
  value       = aws_secretsmanager_secret.secrets_uw.arn
}