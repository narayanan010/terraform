module "aws_documentDB_module" {
  # source = "git@github.com:capterra/terraform.git//modules/aws-waf"
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/documentDB"

  cluster_identifier = "reviews-dev"
  master_username    = "crf_team"
  instance_class     = "db.t3.medium"
  parameter_key      = "/crf/dev/docDB_pass"
  kms_key            = true
  vpc_id             = "vpc-0bbf500391b214d43"
  docdb_sg_name      = "crf_reviews_dev_docdb_sg"
  subnet_ids         = ["subnet-02651ac3136fe9b49", "subnet-088be2006f2a2d437"]
  cluster_size       = 3

  security_group_ingress_rule = [
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.54.89/32"], sg_ids = [], description = "Bastion us-east-1 (edbas)"}
  ]

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "crf"
  tag_app_component       = "documentDB"
  tag_function            = "DB"
  tag_business_unit       = "gdm"
  tag_app_environment     = "dev"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "narayanan.narasimhan@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "dev"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "crf"
  tag_environment         = "dev"
}
