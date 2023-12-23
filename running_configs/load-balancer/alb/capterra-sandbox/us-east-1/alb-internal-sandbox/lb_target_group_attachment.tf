resource "aws_lb_target_group_attachment" "alb-sandbox-tg-att1" {
  provider         = aws
  target_group_arn = module.aws_lb_module.target_group_arns[0]
  target_id        = "i-0c8855d52dc2d81dc"
  port             = 80 
}

resource "aws_lb_target_group_attachment" "alb-sandbox-tg-att2" {
  provider         = aws
  target_group_arn = module.aws_lb_module.target_group_arns[0]
  target_id        = "i-08b9ef336f47bda21"
  port             = 80 
}