# Deploy
modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::350125959894:role/gdm-admin-access"

# WAF
application   = "crf"
web_acl_scope = "CLOUDFRONT"
vertical      = "capterra"
stage         = "staging"