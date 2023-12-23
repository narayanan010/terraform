data "aws_iam_policy_document" "deployer_iam_policy_document" {
    statement {
        actions = [
            "iam:GetRole",
            "iam:UpdateAssumeRolePolicy",
            "iam:GetPolicyVersion",
            "iam:GetPolicy",
            "iam:PutRolePermissionsBoundary",
            "iam:UpdateRoleDescription",
            "iam:DeletePolicy",
            "iam:CreateRole",
            "iam:DeleteRole",
            "iam:AttachRolePolicy",
            "iam:PutRolePolicy",
            "iam:CreatePolicy",
            "iam:DetachRolePolicy",
            "iam:DeleteRolePolicy",
            "iam:UpdateRole",
            "iam:CreatePolicyVersion",
            "iam:GetRolePolicy",
            "iam:DeletePolicyVersion",
            "iam:PassRole"       
        ],
        resources = [
           "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/capterra-*search-*",
           "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/capterra-*search-*" 
        ]
    }
}

resource "aws_iam_role_policy" "deployer_iam_role_policy" {
    name = "capterra-pol-search-dev-deployer-iam"
    policy = "${data.aws_iam_policy_document.deployer_iam_policy_document.json}"
    role    = "${module.capterra-search-dev-deployer.role_name}"
}

resource "aws_iam_role_policy_attachment" "developer-power-user-attach" {
    role = "${module.capterra-search-dev-developer.role_name}"
    policy_arn  =   "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "deployer-power-user-attach" {
    role = "${module.capterra-search-dev-deployer.role_name}"
    policy_arn  =   "arn:aws:iam::aws:policy/PowerUserAccess"
}


