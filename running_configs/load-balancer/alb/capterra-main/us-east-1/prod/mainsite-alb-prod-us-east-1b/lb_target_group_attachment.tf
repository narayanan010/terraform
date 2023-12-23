resource "aws_lb_target_group_attachment" "tg-mainsite-prod-b-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-mainsite-prod-b.arn
  target_id         = "i-0d06751ad15cf5416"
  port              = 443
}

resource "aws_lb_target_group_attachment" "tg-mainsite-prod-b-att2" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-mainsite-prod-b.arn
  target_id         = "i-0305bea3303c97671"
  port              = 443
}