# AWS infrastructure details
region            = "us-west-2"
region_landing    = "us-east-1"
monitoring        = true
terraform_managed = true

# EKS details
eks_name = "sandbox-eks-test"

# Deploymen tag definition
application       = "eks"
app_component     = "eks"
# technology        = "eks"
vertical          = "capterra"
stage             = "sandbox"
# platform          = ""
system_risk_class = "2"
product           = "capterra"
environment       = "sandbox"
app_contacts      = "capterra-devops"
function          = "network"
business_unit     = "cap-bu"
created_by        = "dan.oliva@gartner.com"