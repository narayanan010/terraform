resource "aws_lb_target_group_attachment" "tga-snowflake-prod-1" {
  target_group_arn = aws_lb_target_group.TG-snowflake-prod.arn
  target_id        = "i-01d8e4a627bb169ad"
  port             = 22
}

resource "aws_lb_target_group_attachment" "tga-snowflake-prod-2" {
  target_group_arn = aws_lb_target_group.TG-snowflake-prod.arn
  target_id        = "i-0f481f65916afcb8f"
  port             = 22
}

resource "aws_lb_target_group_attachment" "tga-or5-prod" {
  target_group_arn = aws_lb_target_group.tg-or5-prod.arn
  target_id        = "i-004d6c76ee011a507"
  port             = 1521
}

resource "aws_lb_target_group_attachment" "tga-edg2-prod-equinix" {
  target_group_arn = aws_lb_target_group.tg-edg2-prod-equinix.arn
  target_id        = "10.114.7.19"
  availability_zone = "all"
  port             = 1521
}

resource "aws_lb_target_group_attachment" "tga-or5dg2-prod" {
  target_group_arn = aws_lb_target_group.tg-or5dg2-prod.arn
  target_id        = "i-0a3635270bb030186"
  port             = 1521
}

resource "aws_lb_target_group_attachment" "tga-edg1-prod-equinix" {
  target_group_arn = aws_lb_target_group.tg-edg1-prod-equinix.arn
  target_id        = "10.114.7.18"
  availability_zone = "all"
  port             = 1521
}