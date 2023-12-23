output "aws_lb_listener_listener-np1-equinix_id" {
  value = aws_lb_listener.listener-np1-equinix.id
}

output "aws_lb_listener_listener-astg2_id" {
  value = aws_lb_listener.listener-astg2.id
}

output "aws_lb_listener_listener-astg3_id" {
  value = aws_lb_listener.listener-astg3.id
}

output "aws_lb_listener_listener-astg7_id" {
  value = aws_lb_listener.listener-astg7.id
}

output "aws_lb_target_group_tg-np1-equinix_id" {
  value = aws_lb_target_group.tg-np1-equinix.id
}

output "aws_lb_target_group_tg-astg2_id" {
  value = aws_lb_target_group.tg-astg2.id
}

output "aws_lb_target_group_tg-astg3_id" {
  value = aws_lb_target_group.tg-astg3.id
}

output "aws_lb_target_group_tg-astg7_id" {
  value = aws_lb_target_group.tg-astg7.id
}

output "aws_lb_target_group_attachment_tg-np1-equinix-att1" {
  value = aws_lb_target_group_attachment.tg-np1-equinix-att1.id
}

output "aws_lb_target_group_attachment_tg-astg2-att1" {
  value = aws_lb_target_group_attachment.tg-astg2-att1.id
}

output "aws_lb_target_group_attachment_tg-astg3-att1" {
  value = aws_lb_target_group_attachment.tg-astg3-att1.id
}

output "aws_lb_target_group_attachment_tg-astg7-att1" {
  value = aws_lb_target_group_attachment.tg-astg7-att1.id
}

output "aws_lb-cap-elb-plinktst_id" {
  value = aws_lb.cap-elb-plinktst.id
}
