output "aws_lb_mainsite-alb-prod-ue1-geo_id" {
  value = aws_lb.mainsite-alb-prod-ue1-geo.id
}

output "aws_lb_target_group_tg-mainsite-prod-geo-us-east-1_id" {
  value = aws_lb_target_group.tg-mainsite-prod-geo-us-east-1.id
}

output "aws_lb_listener_listener-mainsite-alb-prod-ue1-geo_id" {
  value = aws_lb_listener.listener-mainsite-alb-prod-ue1-geo.id
}

output "aws_globalaccelerator_endpoint_group_id" {
  value = aws_globalaccelerator_endpoint_group.mainsite-ga-prod-ue1-geo-EndpointGrp.id
}

output "aws_globalaccelerator_accelerator_ip_addresses" {
  value = aws_globalaccelerator_accelerator.mainsite-ga-prod-ue1-geo-accelerator.ip_sets
}