provider "datadog" {
  api_url  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_url"]
  api_key  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_key"]
  app_key  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["app_key"]
  validate = true
}

data "aws_secretsmanager_secret_version" "datadog" {
  provider = aws.main-resources

  secret_id = "arn:aws:secretsmanager:us-east-1:296947561675:secret:datadog-tf-3vOgk7"
}

data "datadog_role" "dg_admin" {
  filter = "Datadog Admin Role"
}