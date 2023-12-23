resource "aws_route_table_association" "subnet-00530c7b77a3fe199" {
  provider       = aws
  route_table_id = aws_route_table.privrt-us-east-1b.id
  subnet_id      = "subnet-00530c7b77a3fe199"
}

resource "aws_route_table_association" "subnet-03a522af72354073d" {
  provider       = aws
  route_table_id = aws_route_table.privrt-us-east-1a.id
  subnet_id      = "subnet-03a522af72354073d"
}

resource "aws_route_table_association" "subnet-0520d3d584b20a479" {
  provider       = aws
  route_table_id = aws_route_table.privrt-us-east-1a.id
  subnet_id      = "subnet-0520d3d584b20a479"
}

resource "aws_route_table_association" "subnet-09916c91f46cb9dcd" {
  provider       = aws
  route_table_id = aws_route_table.pubrt-us-east-1a.id
  subnet_id      = "subnet-09916c91f46cb9dcd"
}

resource "aws_route_table_association" "subnet-0e32470cc3fffeb76" {
  provider       = aws
  route_table_id = aws_route_table.pubrt-us-east-1b.id
  subnet_id      = "subnet-0e32470cc3fffeb76"
}
