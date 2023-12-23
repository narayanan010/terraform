resource "aws_dynamodb_table" "blog-prod" {
  name                        = "CA_BLOG_SURVEY"
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "UUID"
  table_class                 = "STANDARD"
  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "UUID"
    type = "S"
  }

  server_side_encryption {
    enabled     = false
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
  environment         = "production"
  app_environment     = "production"
  network_environment = "production"
  product             = "blog-ui"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}