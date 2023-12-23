output "aws_lb_mainsite-alb-staging-ue1_id" {
  value = aws_lb.mainsite-alb-staging-ue1.id
}

output "aws_lb_target_group_mainsite-staging-tg-ue1_id" {
  value = aws_lb_target_group.mainsite-staging-tg-ue1.id
}

output "aws_lb_listener_mainsite-alb-staging-ue1-http-listener_id" {
  value = aws_lb_listener.mainsite-alb-staging-ue1-http-listener.id
}

output "aws_lb_listener_mainsite-alb-staging-ue1-https-listener_id" {
  value = aws_lb_listener.mainsite-alb-staging-ue1-https-listener.id
}

output "aws_globalaccelerator_endpoint_group_id" {
  value = aws_globalaccelerator_endpoint_group.mainsitealbstagingue1AccEndpointGrp.id
}