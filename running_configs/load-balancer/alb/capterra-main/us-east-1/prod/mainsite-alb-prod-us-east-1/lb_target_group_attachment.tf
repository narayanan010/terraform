resource "aws_lb_target_group_attachment" "mainsite-tg-prod-us-east-1-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.mainsite-tg-prod-us-east-1.arn
  target_id         = "i-0dc812607b8a189b6"
  port              = 443
}

resource "aws_lb_target_group_attachment" "mainsite-tg-prod-us-east-1-att2" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.mainsite-tg-prod-us-east-1.arn
  target_id         = "i-097156cf9a4437553"
  port              = 443
}