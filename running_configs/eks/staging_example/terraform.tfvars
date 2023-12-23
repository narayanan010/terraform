# AWS infrastructure details
region                = "us-east-1"
monitoring            = true
terraform_managed     = true
iam_deployer_role_arn = "arn:aws:iam::176540105868:role/cap-svc-gha-terraform-deployer"

# EKS details
eks_name                 = "capterra-staging-eks"
namespace                = "staging-example"
eks_deployer_role_arn    = "arn:aws:iam::176540105868:role/assume-eks-staging-cluster-admin"
eks_cluster_iam_role_arn = "arn:aws:iam::176540105868:role/eksctl-capterra-staging-eks-cluster-ServiceRole-8JFK3L91VQ5E"


# Deploymen tag definition
application       = "eks"
app_component     = "eks"
technology        = "eks"
vertical          = "capterra"
stage             = "staging"
platform          = ""
system_risk_class = "2"
product           = "capterra"
environment       = "STAGING"
app_contacts      = "capterra-devops"
function          = "network"
business_unit     = "cap-bu"
created_by        = "dan.oliva@gartner.com"