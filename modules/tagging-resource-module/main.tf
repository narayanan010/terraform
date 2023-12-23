locals {
  label_s3 = replace(lower("${var.vertical}-${var.application}-${var.environment}"),"_","-")
  input = {
    application         = var.application == "" ? var.context.application : { application = var.application }
    app_component       = var.app_component == "" ? var.context.app_component : { app_component = var.app_component }
    function            = var.function == "" ? var.context.function : { function = var.function }
    business_unit       = var.business_unit == "" ? var.context.business_unit : { business_unit = var.business_unit }
    app_environment     = var.app_environment == "" ? var.context.app_environment : { app_environment = var.app_environment }
    app_contacts        = var.app_contacts == "" ? var.context.app_contacts : { app_contacts = var.app_contacts }
    created_by          = var.created_by == "" ? var.context.created_by : { created_by = var.created_by }
    system_risk_class   = var.system_risk_class == "" ? var.context.system_risk_class : { system_risk_class = var.system_risk_class }
    region              = var.region == "" ? var.context.region : { region = var.region }
    network_environment = var.network_environment == "" ? var.context.network_environment : { network_environment = var.network_environment }
    monitoring          = var.monitoring == "" ? var.context.monitoring : { monitoring = var.monitoring }
    terraform_managed   = var.terraform_managed == "" ? var.context.terraform_managed : { terraform_managed = var.terraform_managed }
    vertical            = var.vertical == "" ? var.context.vertical : { vertical = var.vertical }
    product             = var.product == "" ? var.context.product : { product = var.product }
    environment         = var.environment == "" ? var.context.environment : { environment = var.environment }
  }

  tags = merge(
    local.input.application,
    local.input.app_component,
    local.input.function,
    local.input.business_unit,
    local.input.app_environment,
    local.input.app_contacts,
    local.input.created_by,
    local.input.system_risk_class,
    local.input.region,
    local.input.network_environment,
    local.input.monitoring,
    local.input.terraform_managed,
    local.input.vertical,
    local.input.product,
    local.input.environment,
    var.tags,
    data.external.repo_config.result
  )
}

data "external" "repo_config" {
  program = ["bash", "${path.module}/scripts/get_repo_info.sh"]
}
