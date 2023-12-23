# AWS MSK cluster
msk_cluster_name           = "click-streaming-production-001-ue1"
msk_kafka_version          = "2.6.2"
msk_number_of_broker_nodes = 3
msk_broker_instance_type   = "kafka.m5.large"
msk_broker_ebs_size        = 500
msk_broker_client_subnets  = ["subnet-0231e00693814e9ae", "subnet-05d54ce5511ff83cc", "subnet-0eb21cf804e8ae49f"]
msk_encryption_kms_key     = "arn:aws:kms:us-east-1:296947561675:key/e37176db-091e-4b5c-a3e9-aa18d9819345"
msk_cw_logs_retention      = "30"


# AWS memoryDB
memory_db_cluster_name             = "click-streaming-production-ue1"
memory_db_node_type                = "db.t4g.medium"
memory_db_num_replicas_per_shard   = 2
memory_db_engine_version           = "6.2"
memory_db_num_shards               = 2
memory_db_maintenance_window       = "sat:07:30-sat:08:30"
memory_db_snapshot_window          = "08:30-09:30"
memory_db_snapshot_retention_limit = 1
memory_db_tls_enabled              = true


# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true

# Deploymen tag definition
application       = "click-streaming"
app_component     = "data"
vertical          = "capterra"
product           = "capterra"
environment       = "prod"
app_contacts      = "capterradevops@gartner.com"
function          = "cache"
business_unit     = "dm"
system_risk_class = "2"
created_by        = "dan.oliva@gartner.com"
