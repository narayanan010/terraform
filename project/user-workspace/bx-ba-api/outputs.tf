output "aws_ecs_task_bluegreen" {
  value       = concat([aws_ecs_task_definition.api_bluegreen.arn], [aws_ecs_task_definition.api_bluegreen.revision])
  description = "ECS Task bluegreen"
}

output "codedeploy_config01" {
  value = { "appspec.json" : { "config_id" : aws_s3_object.file01.id, "file_versioning" : aws_s3_object.file01.version_id, "object_path" : "s3://${data.terraform_remote_state.common_resources.outputs.bucket_id}/${aws_s3_object.file01.id}" } }
}

output "codedeploy_config02" {
  value = { "create_deployment.json" : { "config_id" : aws_s3_object.file02.id, "file_versioning" : aws_s3_object.file02.version_id, "object_path" : "s3://${data.terraform_remote_state.common_resources.outputs.bucket_id}/${aws_s3_object.file02.id}" } }
}

output "terraform_workspace" {
  value = terraform.workspace
}