# SA settings
namespace    = "velero"
provider_url = "oidc.eks.us-west-2.amazonaws.com/id/DA462AA2E37FAF3A816E3D66B10A4A9E"


# AWS infrastructure details
region                                    = "us-west-2"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Deploymen tag definition
application       = "backup"
vertical          = "capterra"
product           = "velero"
environment       = "prod-dr"
app_contacts      = "capterra_devops"
function          = "federation"
business_unit     = "capterra"
created_by        = "dan.oliva@gartner.com"
app_component     = "capterra"
system_risk_class = 3

