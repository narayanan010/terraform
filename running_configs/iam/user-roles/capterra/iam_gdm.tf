resource "aws_iam_role" "assume_role_ccoe_jenkins" {
  provider = aws.capterra-aws-admin

  name                 = "cross-account-role-ccoe-jenkins"
  description          = "Role to assume deployments from CCoE-Jenkins-deployer"
  max_session_duration = 3600
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowAssumeRole",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : [
              "arn:aws:iam::147721705183:root",
              "arn:aws:iam::581009487515:role/c7npipeline_iam_prod"
            ]
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}

resource "aws_iam_policy" "policy_ccoe_jenkins" {
  provider = aws.capterra-aws-admin

  name        = "IAMGroupManagement"
  description = "Policy to manage groups and policys"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowManageGroupsPolicies",
          "Effect" : "Allow",
          "Action" : [
            "iam:CreateGroup",
            "iam:DeleteGroup",
            "iam:UpdateGroup",
            "iam:DeletePolicy",
            "iam:TagPolicy",
            "iam:CreatePolicy",
            "iam:RemoveUserFromGroup",
            "iam:AddUserToGroup",
            "iam:GetGroup",
            "iam:AttachGroupPolicy",
            "iam:DeleteRolePolicy",
            "iam:DetachGroupPolicy",
            "iam:DeleteGroupPolicy",
            "iam:PutGroupPolicy"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:group/*",
            "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:policy/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "attach_ccoe_jenkins" {
  provider = aws.capterra-aws-admin

  role       = aws_iam_role.assume_role_ccoe_jenkins.name
  policy_arn = aws_iam_policy.policy_ccoe_jenkins.arn
}
