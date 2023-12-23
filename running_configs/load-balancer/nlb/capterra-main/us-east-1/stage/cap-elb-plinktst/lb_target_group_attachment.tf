resource "aws_lb_target_group_attachment" "tg-np1-equinix-att1" {
  provider          = aws
  target_group_arn  = aws_lb_target_group.tg-np1-equinix.arn
  target_id         = "10.114.3.32"
  port              = 1521
  availability_zone = "all"
}

resource "aws_lb_target_group_attachment" "tg-astg2-att1" {
  provider         = aws
  target_group_arn = aws_lb_target_group.tg-astg2.arn
  target_id        = "i-00d31cc9986674d88"
  port             = 1521
}

resource "aws_lb_target_group_attachment" "tg-astg3-att1" {
  provider         = aws
  target_group_arn = aws_lb_target_group.tg-astg3.arn
  target_id        = "i-05cb9349db8ad5bdc"
  port             = 1521
}

resource "aws_lb_target_group_attachment" "tg-astg7-att1" {
  provider         = aws
  target_group_arn = aws_lb_target_group.tg-astg7.arn
  target_id        = "i-0c5e38fe2a263b81b"
  port             = 1521
}