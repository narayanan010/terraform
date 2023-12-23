# Deploy
deploy_account_role = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"

# Common
vertical    = "dm"
environment = "sandbox"
application = "vst"

# Database
database_name                = "vst_rcs_db"
engine                       = "aurora-postgresql"
engine_mode                  = "provisioned"
engine_version               = "14.6"
primary_instance_class       = "db.r6g.xlarge"
secondary_instance_class     = "db.r6g.large"
performance_insights_enabled = true

# Storage & Backup
storage_encrypted       = true
backup_retention_period = 28
skip_final_snapshot     = true

# Subnet Groups
primary_subnet_ids   = ["subnet-0689e3a2a6d259eb1", "subnet-09c38ad74f8e65b66", "subnet-0890c5d8800f28422"]
secondary_subnet_ids = ["subnet-00b414ef6edee73d1", "subnet-0d475b891c16a0d7d"]

# Primary
primary_cluster_instance_count = 1
# primary_kms_arn             = "arn:aws:kms:us-east-1:944864126557:key/faa596a6-517f-4c4d-a2dd-7b3835554925"

# Secondary
secondary_cluster_instance_count = 1
# secondary_kms_arn            = "arn:aws:kms:us-west-2:944864126557:key/fed6cb26-74b1-46b5-8b78-b6877d2ccbf7"

# Security groups
primary_vpc_id   = "vpc-0359e3db4acc30c0f"
secondary_vpc_id = "vpc-22abc05b"
primary_security_group_ingress_rule = [
  { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.100.0.0/16"], sg_ids = [], description = "PostgreSQL access from within VPC" }
]

secondary_security_group_ingress_rule = [
  { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.100.0.0/16"], sg_ids = [], description = "PostgreSQL access from within VPC" }
]


# Tags

tag_app_component     = "rds"
tag_function          = "database"
tag_business_unit     = "gdm"
tag_app_contacts      = "capterra_devops"
tag_created_by        = "fabio.perrone@gartner.com"
tag_system_risk_class = "3"
tag_monitoring        = "false"
tag_terraform_managed = "true"
tag_vertical          = "capterra"
tag_product           = "rds"
tag_default_region    = ""