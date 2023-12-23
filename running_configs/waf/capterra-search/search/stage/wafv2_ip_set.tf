resource "aws_wafv2_ip_set" "capterra-nginx-servers-staging-ip-set-search" {
  provider           = aws.primary
  name               = "capterra-nginx-servers-staging-ip-set-search"
  description        = "IP set to whitelist Stage Nginx IP addresses for Search Staging CloudFront ACL"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
                        "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32", 
                        "34.234.249.188/32","35.174.34.104/32", "34.207.38.254/32", 
                        "52.39.77.81/32"]
}