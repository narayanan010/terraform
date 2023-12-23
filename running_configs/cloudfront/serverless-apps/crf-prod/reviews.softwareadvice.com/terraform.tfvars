# Distribution
region                                    = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
aws_wafv2_web_acl_name                    = "arn:aws:wafv2:us-east-1:738909422062:global/webacl/capterra-crf-prod-waf/bedd4298-5f56-45c4-a8fb-4a26249455d6"
cf_origin_access_control                  = "E3HHX2WMEEHOPY"

# Deployment tag definition

tag_application                           = "crf"
tag_app_component                         = "cloudfront"
tag_function                              = "cache"
tag_business_unit                         = "cap-bu"
tag_app_environment                       = "prod"
tag_app_contacts                          = "capterra_devops"
tag_created_by                            = "narayanan.narasimhan@gartner.com"
tag_system_risk_class                     = "3"
tag_region                                = "us-east-1"
tag_network_environment                   = "prod"
tag_monitoring                            = "true"
tag_terraform_managed                     = "true"
tag_vertical                              = "softwareadvice"
tag_product                               = "softwareadvice"
tag_environment                           = "prod"
