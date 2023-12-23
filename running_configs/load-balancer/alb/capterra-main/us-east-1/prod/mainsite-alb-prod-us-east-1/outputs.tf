output "aws_lb_mainsite-alb-prod-us-east-1_id" {
  value = aws_lb.mainsite-alb-prod-us-east-1.id
}

output "aws_lb_target_group_mainsite-tg-prod-us-east-1_id" {
  value = aws_lb_target_group.mainsite-tg-prod-us-east-1.id
}

output "aws_lb_listener_http-listener-80_id" {
  value = aws_lb_listener.http-listener-80.id
}

output "aws_lb_listener_https-listener-443_id" {
  value = aws_lb_listener.https-listener-443.id
}