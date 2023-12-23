locals {
  codedeploy_config_file01 = "${path.module}/source/appspec.json"
  codedeploy_config_file02 = "${path.module}/source/create_deployment.json"
}

resource "local_file" "codedeploy_config01" {
  content = jsonencode(
    {
      "version" : "1.${aws_ecs_task_definition.api_bluegreen.revision}",
      "Resources" : [
        {
          "TargetService" : {
            "Type" : "AWS::ECS::Service",
            "Properties" : {
              "TaskDefinition" : aws_ecs_task_definition.api_bluegreen.arn,
              "LoadBalancerInfo" : {
                "ContainerName" : local.ecs_task,
                "ContainerPort" : 80
              }
            }
          }
        }
      ]
    }
  )
  filename = local.codedeploy_config_file01

  lifecycle {
    replace_triggered_by = [
      aws_ecs_task_definition.api_bluegreen.arn
    ]
  }

  depends_on = [aws_ecs_task_definition.api_bluegreen]
}

resource "local_file" "codedeploy_config02" {
  content = jsonencode(
    {
      "applicationName" : data.terraform_remote_state.common_resources.outputs.codedeploy_dg_api_bluegreen_name,
      "deploymentGroupName" : data.terraform_remote_state.common_resources.outputs.codedeploy_dg_api_bluegreen_name,
      "revision" : {
        "revisionType" : "S3",
        "s3Location" : {
          "bucket" : data.terraform_remote_state.common_resources.outputs.bucket_id,
          "key" : "appspec.json",
          "bundleType" : "JSON"
        }
      }
    }
  )
  filename = local.codedeploy_config_file02
}

# Upload file after modify
resource "aws_s3_object" "file01" {
  provider     = aws.buckets

  bucket       = data.terraform_remote_state.common_resources.outputs.bucket_id
  key          = "appspec.json"
  source       = local.codedeploy_config_file01
  content_type = "application/json"

  lifecycle {
    replace_triggered_by = [local_file.codedeploy_config01.id, aws_ecs_task_definition.api_bluegreen.arn]
    ignore_changes       = [etag]
  }

  depends_on = [local_file.codedeploy_config01]
}

resource "aws_s3_object" "file02" {
  provider     = aws.buckets

  bucket       = data.terraform_remote_state.common_resources.outputs.bucket_id
  key          = "create_deployment.json"
  source       = local.codedeploy_config_file02
  content_type = "application/json"

  lifecycle {
    replace_triggered_by = [local_file.codedeploy_config02.id]
    ignore_changes       = [etag]
  }

  depends_on = [local_file.codedeploy_config02]
}
