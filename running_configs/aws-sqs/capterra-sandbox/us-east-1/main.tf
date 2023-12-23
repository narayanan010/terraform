module "aws_sqs_module" {
  source = "../../../../modules/aws-sqs"

  queue_name = "Sandbox_test.fifo"
  delay_seconds = "90"
  max_message_size = "2048"
  receive_wait_time_seconds = "10"
  kms_key_req = true
  fifo_queue = true
  role_name_sqs = ["arn:aws:iam::944864126557:root", "arn:aws:iam::377773991577:root"]
  dlq_required = true
  #source_queues = []

  #Specify tags here
  tag_application         = "sandbox"
  tag_app_component       = "sqs"
  tag_function            = "messaging"
  tag_business_unit       = "gdm"
  tag_app_environment     = "stage"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "yajush.garg@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "staging"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "sandbox"
  tag_environment         = "staging"
}