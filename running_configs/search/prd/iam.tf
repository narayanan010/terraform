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

data "aws_iam_policy_document" "api_gw_role_policy_document" {
    statement {
        actions = ["sts.AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["apigateway.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy" "deployer_iam_role_policy" {
    name = "capterra-pol-prd-search-deployer-iam"
    policy = "${data.aws_iam_policy_document.deployer_iam_policy_document.json}"
    role    = "${module.capterra-search-prd-deployer.role_name}"
}

resource "aws_iam_policy" "developer_iam_policy" {
    name = "capterra-pol-prd-search-developer-iam"
    policy = "${data.aws_iam_policy_document.deployer_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "developer-power-user-attach" {
    role = "${module.capterra-search-prd-developer.role_name}"
    policy_arn  =   "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "deployer-power-user-attach" {
    role = "${module.capterra-search-prd-deployer.role_name}"
    policy_arn  =   "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "deployer-iam-attach" {
    role = "${module.capterra-search-prd-developer.role_name}"
    policy_arn  =   "${aws_iam_policy.developer_iam_policy.arn}"
}

module "scalyr_streaming_user" {
    source = "/Users/ctaras/repos/terraform-iam/iam-service-account"
    iam_user_name = "capterra-user-scalyr-streaming"
}

module "es_user" {
    source = "/Users/ctaras/repos/terraform-iam/iam-service-account"
    iam_user_name = "capterra-user-search-prd-es"
}

resource "aws_iam_user_policy_attachment" "es_user" {
    user        = "${module.es_user.user_name}"
    policy_arn  = "arn:aws:iam::aws:policy/AmazonESFullAccess"
}

resource "aws_iam_user_policy_attachment" "this" {    
    user        =   "${module.scalyr_streaming_user.user_name}"
    policy_arn  =   "${module.search_cf_dist.scalyr_user_policy}"
}

resource "aws_iam_role" "api_gateway_logs" {
    name = "capterra-role-apigateway-logs"
    assume_role_policy = "${data.aws_iam_policy_document.api_gw_role_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "api_gateway_logs_attach" {
    role = "${aws_iam_role.api_gateway_logs.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}