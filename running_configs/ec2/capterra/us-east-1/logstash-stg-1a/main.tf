resource "aws_security_group" "logstash_sg" {
  name        = "cap-sg-logstash-stg"
  description = "security group for logstash access"
  vpc_id      = "vpc-60714d06"

}

# resource "aws_ebs_volume" "logstash_root" {
#     availability_zone = "us-east-1a"
#     encrypted = true
#     size = 30
# }

# resource "aws_volume_attachment" "logstash_root_attach" {
#     device_name = "/dev/sdf"
#     volume_id = "aws_ebs_volume.logstash_root.id"
#     instance_id = "aws_instance.logstash_instance.id"
# }

resource "aws_instance" "logstash_instance" {
  ami                    = "ami-06a1d281b21fed6f6"
  instance_type          = "r5.2xlarge"
  availability_zone      = "us-east-1a"
  key_name               = "dev-nonprod-general-purpose-key"
  iam_instance_profile   = "CapterraBadgeLogstashInstanceProfile"
  monitoring             = "true"
  vpc_security_group_ids = ["sg-022e2202848b95563", "sg-581e6e27"]
  subnet_id              = "subnet-69726f44"
  root_block_device {
    delete_on_termination = "true"
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
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "sarvesh.gupta@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "staging"
  #   monitoring                     = var.tag_monitoring
  terraform_managed = "true"
  #   vertical                       = var.tag_vertical
  #   product                        = var.tag_product
  environment = "staging"

  #Add Other tags here that you want to apply to all resources, those are to be added to the resources apart from standard tags from Gartner/Capterra.
  tags = {
    "Name"             = "logstash-stg-1a",
    "ENVIRONMENT"      = "STAGING",
    "APPLICATION"      = "logstash",
    "repository"       = "https://github.com/capterra/terraform.git",
    "Backup"           = "yes",
    "BackupSchedule"   = "6",
    "NoReboot"         = "true",
    "RetentionDays"    = "15",
    "TenableAgent"     = "True",
    "backup-dlm"       = "staging",
    "ignore_cpu_alert" = "yes"
  }
}
