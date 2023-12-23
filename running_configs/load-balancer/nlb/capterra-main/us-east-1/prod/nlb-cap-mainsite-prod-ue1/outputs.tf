output "aws_lb_listener_listener-nlb-cap-mainsite-prod-ue1" {
  value = aws_lb_listener.listener-nlb-cap-mainsite-prod-ue1.id
}

output "aws_lb_target_group_tg-capterra-mainsite-prd-ue1_id" {
  value = aws_lb_target_group.tg-capterra-mainsite-prd-ue1.id
}

output "aws_lb-nlb-cap-mainsite-prod-ue1_id" {
  value = aws_lb.nlb-cap-mainsite-prod-ue1.id
}