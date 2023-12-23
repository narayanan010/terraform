# AWS infrastructure details
region                = "us-west-2"
monitoring            = true
terraform_managed     = true
iam_deployer_role_arn = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"


# EKS details
eks_name              = "sandbox-eks-test"
namespace             = "newteam55"
eks_deployer_role_arn = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
#eks_cluster_iam_role_arn = data.terraform_remote_state.eks_cluster_sandbox.outputs.eks_cluster_iam_role_arn

# Deploymen tag definition
application       = "eks"
app_component     = "eks"
technology        = "eks"
vertical          = "capterra"
stage             = "sandbox"
platform          = ""
system_risk_class = "2"
product           = "capterra"
environment       = "SANDBOX"
app_contacts      = "capterra-devops"
function          = "network"
business_unit     = "cap-bu"
created_by        = "dan.oliva@gartner.com"