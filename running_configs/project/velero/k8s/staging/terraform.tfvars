# SA settings
namespace    = "velero"
provider_url = "oidc.eks.us-east-1.amazonaws.com/id/25A06630668756A639F64BB6A74AA760"


# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Deploymen tag definition
application       = "backup"
vertical          = "capterra"
product           = "velero"
environment       = "staging"
app_contacts      = "capterra_devops"
function          = "federation"
business_unit     = "capterra"
created_by        = "dan.oliva@gartner.com"
app_component     = "capterra"
system_risk_class = 3

