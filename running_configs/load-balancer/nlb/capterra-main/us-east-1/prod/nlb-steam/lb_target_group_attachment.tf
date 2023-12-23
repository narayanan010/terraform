resource "aws_lb_target_group_attachment" "TG-steam-FWKNOP-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.TG-steam-FWKNOP.arn
  target_id         = "i-073dc7d76a2886849"
  port              = 62201
}

resource "aws_lb_target_group_attachment" "TG-steam-SSH-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.TG-steam-SSH.arn
  target_id         = "i-073dc7d76a2886849"
  port              = 22
}