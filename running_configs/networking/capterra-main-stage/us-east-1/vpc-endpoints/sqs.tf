module "sqs-vpc-endpoints" {
  source                  = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/vpc-endpoint"
  vpc_id                  = var.vpc_id
  interface_vpc_endpoints = {
    "sqs" = {
      name                = "com.amazonaws.us-east-1.sqs"
      subnet_ids          = var.sqs_vpc_endpoint_subnet_ids
      policy              = null
      security_group_ids  = [aws_security_group.sqs_endpoint.id]
      private_dns_enabled = true
      application_tag     = "sqs"
    }
  }
}