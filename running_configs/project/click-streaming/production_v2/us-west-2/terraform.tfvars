
# AWS infrastructure details
region                                    = "us-west-2"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"

# Datadog Alerts
alerts_to = "@slack-alert_click_streaming"


# AWS MSK cluster
msk_cluster_name           = "click-streaming-production-dr-001-uw2"
msk_kafka_version          = "2.6.2"
msk_number_of_broker_nodes = 3
msk_broker_instance_type   = "kafka.m5.large"
msk_broker_ebs_size        = 500
msk_broker_client_subnets  = ["subnet-095309c0629cd20bf", "subnet-0b575f7aa82e4d0f2", "subnet-08eb96f92f58c5aa5"]
msk_cw_logs_retention      = "30"

# Deploymen tag definition
application       = "click-streaming"
app_component     = "data"
vertical          = "capterra"
product           = "capterra"
environment       = "prod-dr"
app_contacts      = "capterradevops@gartner.com"
function          = "cache"
business_unit     = "dm"
system_risk_class = "2"
created_by        = "dan.oliva@gartner.com"


# AWS memoryDB
memory_db_cluster_name             = "click-streaming-production-uw2"
memory_db_node_type                = "db.t4g.medium"
memory_db_num_replicas_per_shard   = 2
memory_db_engine_version           = "6.2"
memory_db_num_shards               = 2
memory_db_maintenance_window       = "sat:07:30-sat:08:30"
memory_db_snapshot_window          = "08:30-09:30"
memory_db_snapshot_retention_limit = 1
memory_db_tls_enabled              = true