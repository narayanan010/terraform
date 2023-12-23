module "scalyr_cloudwatch_module" {
  source                  = "../../../modules/scalyr-cloudwatch-module"
  region_aws              = var.modulecaller_source_region
  BaseUrl		              = var.BaseUrl
  AutoSubscribeLogGroups  = var.AutoSubscribeLogGroups
  Debug				 			      = var.Debug
  WriteLogsKey					  = var.WriteLogsKey
  WriteLogsKeyEncrypted		= var.WriteLogsKeyEncrypted
  LogGroupOptions				  = var.LogGroupOptions
  template_url            = var.template_url
  
  #capabilities = ["CAPABILITY_IAM","CAPABILITY_NAMED_IAM","CAPABILITY_AUTO_EXPAND"]
  scalyrplainapikeytoencrypt = var.scalyrplainapikeytoencrypt

  providers = {
    aws.awscaller_account = "aws.awscaller_account"
    #aws.capterra-aws-admin = "aws.capterra-aws-admin"
  }
}