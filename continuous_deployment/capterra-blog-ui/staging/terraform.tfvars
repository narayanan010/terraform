modulecaller_source_region = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
cname_aliases = ["resources.capstage.net"]
default_origin_dns = "lb-resources.capstage.net"
hosted_zone_id = "Z735WTNG1JTY0"
web_acl_arn = "arn:aws:wafv2:us-east-1:176540105868:global/webacl/capterra-cloudfront-troubleshooting-waf/6a65cc38-bfeb-4c35-b5fe-e05850172437" # To be changed --> Narayanan is working on new WAF
acm_certificate_arn = "arn:aws:acm:us-east-1:176540105868:certificate/3ef8a4cd-b4cf-482e-bb70-2c313a7c63fc"
