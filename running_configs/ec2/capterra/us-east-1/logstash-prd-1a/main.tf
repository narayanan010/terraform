resource "aws_security_group" "logstash_sg" {
  name        = "cap-sg-logstash-prd"
  description = "security group for logstash access"
  vpc_id      = "vpc-c2ecc1a4"

}

resource "aws_instance" "logstash_instance" {
  ami                    = "ami-06a1d281b21fed6f6"
  instance_type          = "m5.4xlarge"
  availability_zone      = "us-east-1a"
  key_name               = "prod-us-east-1-capterra-general-purpose-key"
  iam_instance_profile   = "CapterraBadgeLogstashInstanceProfile"
  monitoring             = "true"
  vpc_security_group_ids = ["sg-00214868eff141cdd", "sg-68df5017"]
  subnet_id              = "subnet-87666faa"
  root_block_device {
    delete_on_termination = "false"
    volume_type           = "gp2"
    encrypted             = "true"
  }
  tags = module.tags_resource_module.tags

}


#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  source              = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"
  application         = "logstash"
  app_component       = "capterra"
  function            = "logserver"
  business_unit       = "gdm"
  app_environment     = "production"
  app_contacts        = "capterra_devops"
  created_by          = "Colin.taras@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "production"
  terraform_managed   = "true"
  environment         = "production"

  #Add Other tags here that you want to apply to all resources, those are to be added to the resources apart from standard tags from Gartner/Capterra.
  tags = {
    "Name"             = "logstash-prd-1a",
    "ENVIRONMENT"      = "PRODUCTION",
    "APPLICATION"      = "logstash",
    "repository"       = "https://github.com/capterra/terraform.git",
    "Backup"           = "yes",
    "BackupSchedule"   = "5",
    "NoReboot"         = "true",
    "RetentionDays"    = "15",
    "backup-dlm"       = "prod",
    "ignore_cpu_alert" = "yes"
  }
}
