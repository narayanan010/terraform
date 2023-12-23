resource "aws_lb_target_group_attachment" "tg-capterra-mainsite-prd-ue1-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-capterra-mainsite-prd-ue1.arn
  target_id         = "i-0dc812607b8a189b6"
  port              = 443
}

resource "aws_lb_target_group_attachment" "tg-capterra-mainsite-prd-ue1-att2" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-capterra-mainsite-prd-ue1.arn
  target_id         = "i-0305bea3303c97671"
  port              = 443
}

resource "aws_lb_target_group_attachment" "tg-capterra-mainsite-prd-ue1-att3" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-capterra-mainsite-prd-ue1.arn
  target_id         = "i-0d06751ad15cf5416"
  port              = 443
}

resource "aws_lb_target_group_attachment" "tg-capterra-mainsite-prd-ue1-att4" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-capterra-mainsite-prd-ue1.arn
  target_id         = "i-097156cf9a4437553"
  port              = 443
}