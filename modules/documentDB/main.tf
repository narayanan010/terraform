terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.67.0"
        configuration_aliases = [ aws.primary ]
      }
  }
}

/*resource "random_password" "password" {
  count   = var.master_password != "" ? 0 : 1
  length  = 16
  special = false
}*/

data "aws_ssm_parameter" "DocDB_cluster_password" {
  provider = aws.primary
  name = var.parameter_key
}

data "aws_caller_identity" "current" {
  provider = aws.primary
}
#*************************************************************************************************************************************************************#
#                                                      			       Security Group     	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_security_group" "docdb_sg" {
  provider        = aws.primary
  name            = var.docdb_sg_name
  vpc_id          = var.vpc_id

  description     = "Allow traffic into Document DB"
  dynamic "ingress" {
    for_each  = var.security_group_ingress_rule
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.sg_ids
      description     = ingress.value.description
    }
  }

  tags = module.tags_resource_module.tags
}

#*************************************************************************************************************************************************************#
#                                                      			       KMS Key     	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_kms_key" "kms_key_aws" {
  provider                        = aws.primary

  count                           = var.kms_key ? 1 : 0
  description                     = "KMS Key for DocumentDB cluster"
  key_usage                       = "ENCRYPT_DECRYPT"
  is_enabled                      = true
  enable_key_rotation             = true
  customer_master_key_spec        = "SYMMETRIC_DEFAULT"
  tags                            = module.tags_resource_module.tags
  #policy                          = filebase64sha256("${path.module}/kms-policy.json.tpl")
  policy                          =  <<-EOT

                              {

                                "Version": "2012-10-17",
	                              "Id": "auto-rds-2",
	                              "Statement": [{
	                              	"Sid": "Allow access for the current account that is authorized to use DocumentDB",
	                              	"Effect": "Allow",
	                              	"Principal": {
	                              		"AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
	                              	},
	                              	"Action": [
	                              		"kms:*"
	                              	],
	                              	"Resource": "*"
	                              }]
                                }
                                EOT
}


#*************************************************************************************************************************************************************#
#                                                      			       Document Db cluster     	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_docdb_cluster" "docdb" {
  provider                        = aws.primary
  cluster_identifier              = var.cluster_identifier
  engine                          = var.engine
  master_username                 = var.master_username
  #master_password                 = var.master_password != "" ? var.master_password : random_password.password[0].result
  master_password                 = data.aws_ssm_parameter.DocDB_cluster_password.value
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  #final_snapshot_identifier       = lower("${aws_docdb_cluster.docdb.id}")
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  apply_immediately               = var.apply_immediately
  storage_encrypted               = var.storage_encrypted
  #kms_key_id                      = var.kms_key_id
  kms_key_id                      = var.kms_key_id == null ? aws_kms_key.kms_key_aws[0].key_id : var.kms_key_id
  port                            = var.db_port
  #snapshot_identifier             = var.snapshot_identifier
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.default.name
  db_subnet_group_name            = aws_docdb_subnet_group.default.name
  vpc_security_group_ids          = [aws_security_group.docdb_sg.id]
  engine_version                  = var.engine_version
  #enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = module.tags_resource_module.tags
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  provider                        = aws.primary

  count                           = var.cluster_size
  identifier                      = "${aws_docdb_cluster.docdb.id}-${count.index + 1}"
  cluster_identifier              = aws_docdb_cluster.docdb.id
  apply_immediately               = var.apply_immediately
  instance_class                  = var.instance_class
  engine                          = var.engine
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  enable_performance_insights     = var.enable_performance_insights
  tags                            = module.tags_resource_module.tags
}

resource "aws_docdb_subnet_group" "default" {
  provider                        = aws.primary
  name                            = "${var.cluster_identifier}-subnet-group"
  subnet_ids                      = var.subnet_ids
  tags                            = module.tags_resource_module.tags
}

resource "aws_docdb_cluster_parameter_group" "default" {
  provider                        = aws.primary
  family                        = var.param_family
  name                          = "${var.cluster_identifier}-parameter-group"
  description                   = "docdb cluster parameter group"
}

#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  source                         = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  application                    = var.tag_application
  app_component                  = var.tag_app_component
  function                       = var.tag_function
  business_unit                  = var.tag_business_unit
  app_environment                = var.tag_app_environment
  app_contacts                   = var.tag_app_contacts
  created_by                     = var.tag_created_by
  system_risk_class              = var.tag_system_risk_class
  region                         = var.tag_region
  network_environment            = var.tag_network_environment             
  monitoring                     = var.tag_monitoring
  terraform_managed              = var.tag_terraform_managed
  vertical                       = var.tag_vertical
  product                        = var.tag_product
  environment                    = var.tag_environment

  #Add Other tags here that you want to apply to all resources, those are to be added to the resources apart from standard tags from Gartner/Capterra.
  tags = {
    "terraform_managed" = "true",
    "repository"        = "https://github.com/capterra/terraform.git"
  } 
}
