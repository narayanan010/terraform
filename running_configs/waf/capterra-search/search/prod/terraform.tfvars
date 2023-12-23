# Deploy
modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"

# WAF
application   = "search"
web_acl_scope = "CLOUDFRONT"
vertical      = "capterra"
stage         = "prod"