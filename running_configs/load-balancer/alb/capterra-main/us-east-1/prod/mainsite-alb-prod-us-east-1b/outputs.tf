output "aws_lb_mainsite-alb-prod-us-east-1b_id" {
  value = aws_lb.mainsite-alb-prod-us-east-1b.id
}

output "aws_lb_target_group_tg-mainsite-prod-b_id" {
  value = aws_lb_target_group.tg-mainsite-prod-b.id
}

output "aws_lb_listener_https_listener_mainsite_prod_b_id" {
  value = aws_lb_listener.https_listener_mainsite_prod_b.id
}

output "aws_lb_listener_http_listener_mainsite_prod_b_id" {
  value = aws_lb_listener.http_listener_mainsite_prod_b.id
}