# AWS MSK cluster
msk_cluster_name           = "click-streaming-staging-001-ue1"
msk_kafka_version          = "2.6.2"
msk_number_of_broker_nodes = 3
msk_broker_instance_type   = "kafka.t3.small"
msk_broker_ebs_size        = 600
msk_broker_client_subnets  = ["subnet-089258bf9059259d3", "subnet-0272efa24d4855bfb", "subnet-09f42dd6431604575"]
msk_encryption_kms_key     = "arn:aws:kms:us-east-1:273213456764:key/88cbceda-1bbb-4751-be59-933f934b91f6"
msk_cw_logs_retention      = "7"


# AWS memoryDB
memory_db_cluster_name             = "click-streaming-staging-ue1"
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

# Datadog Alerts
alerts_to = "@slack-alert_click_streaming_stg"

# Deploymen tag definition
application       = "click-streaming"
app_component     = "data"
vertical          = "capterra"
stage             = "staging"
product           = "capterra"
environment       = "staging"
app_contacts      = "capterra-devops"
function          = "cache"
business_unit     = "cap-bu"
system_risk_class = "1"
created_by        = "dan.oliva@gartner.com"
