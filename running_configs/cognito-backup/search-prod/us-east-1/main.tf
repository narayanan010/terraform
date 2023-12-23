module "cognito_backup" {
    source = "../../../../modules/cognito-backup"
    environment = var.environment
    vertical = var.vertical
    region = var.region
}