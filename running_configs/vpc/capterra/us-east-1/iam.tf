resource "aws_iam_role_policy" "vpc_cw_logs_policy" {
  name_prefix  = "vpc_flowlogs_policy-"
  role = aws_iam_role.vpc_cw_logs_role.id
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "vpc_cw_logs_role" {
  name_prefix  = "VPC-Flow-Logs-Role-"
  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "vpc-flow-logs.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }   
  )
}