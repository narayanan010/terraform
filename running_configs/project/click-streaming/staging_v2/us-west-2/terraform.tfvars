# AWS infrastructure details
region                                    = "us-west-2"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"

# Datadog Alerts
alerts_to = "@slack-alert_click_streaming_stg"

# AWS MSK cluster
msk_cluster_name           = "click-streaming-staging-dr-001-uw2"
msk_kafka_version          = "2.6.2"
msk_number_of_broker_nodes = 2
msk_broker_instance_type   = "kafka.t3.small"
msk_broker_ebs_size        = 300
msk_broker_client_subnets  = ["subnet-049b7acdbea065f63", "subnet-0b930923ce343955b"]
msk_cw_logs_retention      = "7"

# Deploymen tag definition
application       = "click-streaming"
app_component     = "data"
vertical          = "capterra"
product           = "capterra"
environment       = "staging-dr"
app_contacts      = "capterradevops@gartner.com"
function          = "cache"
business_unit     = "dm"
system_risk_class = "2"
created_by        = "dan.oliva@gartner.com"
