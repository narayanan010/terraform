output "aws_lb_listener_http_id" {
  value = aws_lb_listener.frontend_http_tcp.id
}

output "aws_lb_listener_https_id" {
  value = aws_lb_listener.frontend_https.id
}

output "nlb-test-tf-import-tg2_id" {
  value = aws_lb_target_group.nlb-test-tf-import-tg2.id
}

output "nlb-test-tf-import-tg_id" {
  value = aws_lb_target_group.nlb-test-tf-import-tg.id
}

output "aws_lb_nlb-test-tf-import_id" {
  value = aws_lb.nlb-test-tf-import.id
}
