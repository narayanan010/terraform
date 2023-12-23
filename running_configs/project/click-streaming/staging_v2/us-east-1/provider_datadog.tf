provider "datadog" {
  api_url  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_url"]
  api_key  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_key"]
  app_key  = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["app_key"]
  validate = true
}

data "aws_secretsmanager_secret_version" "datadog" {
  secret_id = "datadog-tf"
}

data "datadog_role" "dg_admin" {
  filter = "Datadog Admin Role"
}
