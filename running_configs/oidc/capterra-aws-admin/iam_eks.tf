##### IAM policy EKS capterra

resource "aws_iam_policy" "github_actions_eks1" {
  name        = "tf-capterra-pol-assume-cap-svc-gha-eks-deployer-main-account"
  description = "Admin access to EKS clusters"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Production",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::176540105868:role/assume-eks-production-cluster-admin"
        },
        {
          "Sid" : "ProductionDR",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::176540105868:role/assume-eks-production-dr-cluster-admin"
        },
        {
          "Sid" : "Staging",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::176540105868:role/assume-eks-staging-cluster-admin"
        },
        {
          "Sid" : "Dev",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::176540105868:role/assume-eks-dev-cluster-admin"
        }
      ]
    }
  )
}


##### IAM policy EKS sandbox
resource "aws_iam_policy" "github_actions_eks2" {
  name        = "tf-capterra-pol-assume-cap-svc-gha-eks-deployer-sandbox-account"
  description = "Admin access to EKS clusters"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Sandbox",
          "Effect" : "Allow",
          "Action" : [
            "eks:*",
            "ec2:DescribeAccountAttributes"
          ],
          "Resource" : "arn:aws:iam::944864126557:role/assume-eks-sandbox-cluster-admin"
        }
      ]
    }
  )
}


resource "aws_iam_role_policy_attachment" "github_actions_eks1" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_eks1.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_eks2" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_eks2.arn
}
