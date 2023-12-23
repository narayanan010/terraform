module "iam_assumable_role_admin" {
  source        = "../../../../modules/eks-sa-pod"
  project_name  = var.application
  env           = var.environment
  provider_url  = "oidc.eks.us-east-1.amazonaws.com/id/25A06630668756A639F64BB6A74AA760"
  namespace     = "team-blog"
  providers = {
    aws.awscaller_account = aws.awscaller_account
  }
}

data "template_file" "role_policy" {
  template = "${file("sqs-role-policy.json.tpl")}"
  vars = {
    resource_arn = module.aws_sqs_module.sqs_arn
  }
}

data "aws_dynamodb_table" "tableName" {
  name = aws_dynamodb_table.blog-stage.id
}

resource "aws_iam_policy" "policy" {
name = "${var.application}-${var.environment}-access-eks-pod-${var.environment}-pol"
description = "This policy will be applied iam role that will be mapped to service account in EKS ${var.environment} via OIDC for ${var.application} pod in ${var.environment}"
policy = data.template_file.role_policy.rendered
}

resource "aws_iam_role_policy_attachment" "custom" {
  depends_on = [
    aws_iam_policy.policy
  ]
  role       = module.iam_assumable_role_admin.iam_role_name
  policy_arn = aws_iam_policy.policy.arn
#  providers = {
#    aws.awscaller_account = aws.awscaller_account
#    }
}

module "aws_sqs_module" {
  source                    = "../../../../modules/aws-sqs"
  queue_name                = "${var.application}-${var.environment}"
  fifo_queue                = true
  delay_seconds             = "90"
  max_message_size          = "2048"
  receive_wait_time_seconds = "10"
  maxReceiveCount           = "5"
  kms_key_req               = true
  role_name_sqs             = ["arn:aws:iam::176540105868:root"]
  dlq_required              = true 
  vertical                  = var.vertical
  application               = "${var.application}-sqs-to-oracle-db"
  environment               = var.environment
  dlq_alert_required        = true
  slack_alert_webhook_parameter   = "/devops/slack/blog-ui/sqs-to-oracle-db/staging"
  providers = {
    aws.awscaller_account = aws.awscaller_account  
    }
}

module "aws_lambda_integrator_module" {
  source = "../../../../modules/projects/blog-ui/sqs-to-oracle-db-integrator"

  runtime_lambda = var.runtime_lambda
  memory_size    = var.memory_size
  timeout        = var.timeout
  is_trigger_enabled = var.is_lambda_trigger_enabled

  vertical    = var.vertical
  application = var.application
  environment = var.environment
  vpc_id      = var.vpc_id

  subnets_for_lambda    = var.subnets_for_lambda
  cx_oracle_layer_name  = var.cx_oracle_layer_name
  db_user               = var.db_user
  db_service            = var.db_service
  db_host               = var.db_host
  db_port               = var.db_port
  db_stored_procedure   = var.db_stored_procedure
  db_password_parameter = var.db_password_parameter
  sqs_arn               = module.aws_sqs_module.sqs_arn
  dynamoDB_table_name   = data.aws_dynamodb_table.tableName.name
  sqs_id                = module.aws_sqs_module.sqs_id
  providers = {
    aws.awscaller_account = aws.awscaller_account
  }
}


module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = "blog-ui"
  app_component       = "lambda"
  function            = "sqs-to-db-integration"
  business_unit       = "gdm"
  app_contacts        = "capterra_devops"
  created_by          = "fabio.perrone@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = var.vertical
  environment         = "staging"
  app_environment     = "staging"
  network_environment = "staging"
  product             = "blog-ui"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
