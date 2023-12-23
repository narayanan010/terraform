output "aws_lb_listener_listener_snowflake-prod_id" {
  value = aws_lb_listener.listener_snowflake-prod.id
}

output "aws_lb_listener_listener_or5-prod" {
  value = aws_lb_listener.listener_or5-prod.id
}

output "aws_lb_listener_listener_edg2-prod-equinix" {
  value = aws_lb_listener.listener_edg2-prod-equinix.id
}

output "aws_lb_listener_listener_edg1-prod-equinix" {
  value = aws_lb_listener.listener_edg1-prod-equinix.id
}

output "aws_lb_target_group_TG-snowflake-prod_id" {
  value = aws_lb_target_group.TG-snowflake-prod.id
}

output "aws_lb_target_group_tg-edg2-prod-equinix_id" {
  value = aws_lb_target_group.tg-edg2-prod-equinix.id
}

output "aws_lb_target_group_tg-edg1-prod-equinix_id" {
  value = aws_lb_target_group.tg-edg1-prod-equinix.id
}

output "aws_lb_target_group_tg-or5-prod_id" {
  value = aws_lb_target_group.tg-or5-prod.id
}

output "aws_vpc_endpoint_service_cap-elb-snowflake-prod_vpce_id" {
  value = aws_vpc_endpoint_service.cap-elb-snowflake-prod_vpce.id
}

output "aws_lb-cap-elb-snowflake-prod_id" {
  value = aws_lb.cap-elb-snowflake-prod.id
}

output "aws_lb_target_group_tg-or5dg2-prod_id" {
  value = aws_lb_target_group.tg-or5dg2-prod.id
}