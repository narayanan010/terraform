# Deploy
modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::738909422062:role/assume-crf-production-admin"

# WAF
application   = "crf"
web_acl_scope = "CLOUDFRONT"
vertical      = "capterra"
stage         = "prod"