resource "aws_lb_target_group_attachment" "tg-ataccama-access-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-ataccama-access.arn
  target_id         = "i-05cb9349db8ad5bdc"
  port              = 1521
}
