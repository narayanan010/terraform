resource "aws_dynamodb_table" "blog-stage" {
  name                        = "CA_BLOG_SURVEY_STG"
  billing_mode                = "PROVISIONED"
  hash_key                    = "UUID"
  read_capacity               = 5
  write_capacity              = 5
  table_class                 = "STANDARD"

  attribute {
    name = "UUID"
    type = "S"
  }

  server_side_encryption {
    enabled     = false
    #kms_key_arn = var.server_side_encryption_kms_key_arn
  }
  tags = module.tags_resource_dynamoDB.tags
}

module "tags_resource_dynamoDB" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = "blog-ui"
  app_component       = "dynamoDB"
  function            = "dynamoDB table"
  business_unit       = "gdm"
  app_contacts        = "capterra_devops"
  created_by          = "yajush.garg@gartner.com"
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