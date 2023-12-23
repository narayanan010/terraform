modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
vertical = "capterra"
application = "vp"
environment = "staging"
namespace = "vendor-portal"
provider_url = "oidc.eks.us-east-1.amazonaws.com/id/25A06630668756A639F64BB6A74AA760"

#Organizations
organizations_role_arn_to_assume_list = ["arn:aws:iam::273213456764:role/assume-capterra-search-staging-cognito"]