module "aws_documentDB_module" {
  # source = "git@github.com:capterra/terraform.git//modules/aws-waf"
  source = "../../../../../modules/documentDB"

  cluster_identifier = "reviews-prod"
  master_username = "crf_team"
  instance_class = "db.t4g.medium"
  parameter_key = "/crf/production/docDB_pass"
  enable_performance_insights = true
  #kms_key_id = "arn:aws:kms:us-east-1:350125959894:key/e54f2cb3-0faa-4cc3-b9f8-6c1267b51997"
  vpc_id      = "vpc-0de18ef8cf1d96a82"
  docdb_sg_name = "crf_reviews_prod_docdb_sg"
  subnet_ids = ["subnet-0520d3d584b20a479", "subnet-00530c7b77a3fe199"]
  cluster_size = 3
  kms_key = true

  security_group_ingress_rule = [
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.24.0/24"], sg_ids = [], description = "priv-subnet-1a capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.54.89/32"], sg_ids = [], description = "Bastion us-east-1 (edbas)"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.29.0/24"], sg_ids = [], description = "priv-subnet-1c capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.25.0/24"], sg_ids = [], description = "priv-subnet-1b capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = [], sg_ids = ["sg-0170eed8a55538e78"], description = "Allow traffic from Lambda"}
  ]

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "crf"
  tag_app_component       = "documentDB"
  tag_function            = "DB"
  tag_business_unit       = "gdm"
  tag_app_environment     = "prod"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "yajush.garg@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "prod"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "crf"
  tag_environment         = "prod"
}

module "aws_documentDB" {
  # source = "git@github.com:capterra/terraform.git//modules/aws-waf"
  source = "../../../../../modules/documentDB"

  cluster_identifier = "reviews-prod-cluster"
  master_username = "crf_team"
  instance_class = "db.t4g.medium"
  parameter_key = "/crf/production/docDB_pass"
  enable_performance_insights = true
  #kms_key_id = "arn:aws:kms:us-east-1:350125959894:key/e54f2cb3-0faa-4cc3-b9f8-6c1267b51997"
  vpc_id      = "vpc-0de18ef8cf1d96a82"
  docdb_sg_name = "crf_reviews_prod_docdb_cluster_sg"
  subnet_ids = ["subnet-0520d3d584b20a479", "subnet-00530c7b77a3fe199"]
  engine_version = "5.0.0"
  param_family = "docdb5.0"
  deletion_protection = true
  cluster_size = 3
  kms_key = true

  security_group_ingress_rule = [
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.24.0/24"], sg_ids = [], description = "priv-subnet-1a capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.54.89/32"], sg_ids = [], description = "Bastion us-east-1 (edbas)"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.29.0/24"], sg_ids = [], description = "priv-subnet-1c capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.25.0/24"], sg_ids = [], description = "priv-subnet-1b capterra(main)-prod-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = [], sg_ids = ["sg-0170eed8a55538e78"], description = "Allow traffic from Lambda"}
  ]

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "crf"
  tag_app_component       = "documentDB"
  tag_function            = "DB"
  tag_business_unit       = "gdm"
  tag_app_environment     = "prod"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "fabio.perrone@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "prod"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "crf"
  tag_environment         = "prod"
}
