resource "aws_vpc_endpoint_service" "cap-elb-snowflake-prod_vpce" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.cap-elb-snowflake-prod.arn]
  provider                   = aws
  tags = {
    "APPLICATION" = "SNOWFLAKE"
    "ENVIRONMENT" = "PRODUCTION"
    "TERRAFORM_MANGED" = "TRUE"
  }
  tags_all = {
    "APPLICATION" = "SNOWFLAKE"
    "ENVIRONMENT" = "PRODUCTION"
    "TERRAFORM_MANGED" = "TRUE"
  }
}