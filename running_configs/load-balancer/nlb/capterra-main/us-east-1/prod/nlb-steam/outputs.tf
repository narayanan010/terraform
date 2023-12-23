output "aws_lb_listener_NLB-steam-udp-lsnr_id" {
  value = aws_lb_listener.NLB-steam-udp-lsnr.id
}

output "aws_lb_listener_NLB-steam-tcp-lsnr_id" {
  value = aws_lb_listener.NLB-steam-tcp-lsnr.id
}

output "aws_lb_target_group_TG-steam-FWKNOP_id" {
  value = aws_lb_target_group.TG-steam-FWKNOP.id
}

output "aws_lb_target_group_TG-steam-SSH_id" {
  value = aws_lb_target_group.TG-steam-SSH.id
}

output "aws_lb-NLB-steam_id" {
  value = aws_lb.NLB-steam.id
}