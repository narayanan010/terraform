resource "aws_lb_target_group_attachment" "tg-ataccama-access-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-mainsite-prod-geo-us-east-1.arn
  target_id         = "i-0156901a0e6cc57a2"
  port              = 443
}
