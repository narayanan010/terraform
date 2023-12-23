modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
vertical = "capterra"
application = "vp"
environment = "production"
namespace = "vendor-portal"
provider_url = "oidc.eks.us-east-1.amazonaws.com/id/51B8E962F37D90A01F8E85D53A318C3C"

#Bidding
bidding_role_arn_to_assume_list = ["arn:aws:iam::176540105868:role/assume_role_bidding_ecs_prod", "arn:aws:iam::176540105868:role/s3_unified_vendor_portal_gdm_prod"]