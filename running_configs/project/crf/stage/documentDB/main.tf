module "aws_documentDB" {
  source = "../../../../../modules/documentDB"

  cluster_identifier = "reviews-stage-cluster"
  master_username = "crf_team"
  instance_class = "db.t4g.medium"
  parameter_key = "/crf/staging/docDB_pass"
  enable_performance_insights = false
  kms_key_id = "arn:aws:kms:us-east-1:350125959894:key/e54f2cb3-0faa-4cc3-b9f8-6c1267b51997"
  vpc_id      = "vpc-09f74d554fdba26c3"
  docdb_sg_name = "crf_reviews_staging_docdb_cluster_sg"
  subnet_ids = ["subnet-0915d22014198c484", "subnet-0e3dc826b40ea061d"]
  engine_version = "5.0.0"
  param_family = "docdb5.0"
  deletion_protection = true
  cluster_size = 3

  security_group_ingress_rule = [
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.32.0/24"], sg_ids = [], description = "priv-subnet-1a capterra(main)-stage-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.54.89/32"], sg_ids = [], description = "Bastion us-east-1 (edbas)"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.34.0/24"], sg_ids = [], description = "priv-subnet-1c capterra(main)-stage-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.33.0/24"], sg_ids = [], description = "priv-subnet-1b capterra(main)-stage-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.35.0/24"], sg_ids = [], description = "priv-subnet-1d capterra(main)-stage-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = ["10.114.36.0/24"], sg_ids = [], description = "priv-subnet-1f capterra(main)-stage-vpc"},
    {from_port = 27017, to_port = 27017, protocol = "tcp", cidr_blocks = [], sg_ids = ["sg-0596982cb3764ece3"], description = "Allow traffic from Lambda"}
  ]

  providers = {
      aws.primary = aws.primary
  }

  #Specify tags here
  tag_application         = "crf"
  tag_app_component       = "documentDB"
  tag_function            = "DB"
  tag_business_unit       = "gdm"
  tag_app_environment     = "staging"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "narayanan.narasimhan@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "staging"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "crf"
  tag_environment         = "staging"
}
