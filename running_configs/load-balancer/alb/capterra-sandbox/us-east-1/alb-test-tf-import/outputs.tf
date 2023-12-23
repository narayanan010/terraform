output "aws_lb_listener_tfer_http_id" {
  value = "${aws_lb_listener.frontend_http_tcp.id}"
}

output "aws_lb_listener_tfer_https_id" {
  value = "${aws_lb_listener.frontend_https.id}"
}

output "aws_lb_target_group_tfer_tg_id" {
  value = "${aws_lb_target_group.alb-test-tf-import-tg.id}"
}

output "aws_lb_target_group_tfer_tg2_id" {
  value = "${aws_lb_target_group.alb-test-tf-import-tg2.id}"
}

output "aws_lb_id" {
  value = "${aws_lb.alb-test-tf-import.id}"
}
