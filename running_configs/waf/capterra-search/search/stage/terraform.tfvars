# Deploy
modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"

# WAF
application   = "search"
web_acl_scope = "CLOUDFRONT"
vertical      = "capterra"
stage         = "staging"