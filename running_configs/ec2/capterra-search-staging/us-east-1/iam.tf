data "aws_iam_policy" "SSMAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_SSM_profile" {
  name = "instance_SSM_profile"
  role = aws_iam_role.SSMAccess_role.name
}

resource "aws_iam_role" "SSMAccess_role" {
  name = "SSMAccess_role_EC2"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "SSMAccess_policy_attachment" {
  name       = "SSMAccess_policy_attachment"
  roles      = [aws_iam_role.SSMAccess_role.name]
  policy_arn = data.aws_iam_policy.SSMAccess.arn
}