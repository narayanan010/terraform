resource "aws_wafv2_ip_set" "mainsite-stage-browserstack-ip-set" {
  name               = "mainsite-stage-browserstack-ip-set"
  description        = "IP set to whitelist Browserstack IP addresses for Mainsite Stage ACL"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["207.254.8.13/32", "207.254.8.14/32", "34.204.63.20/32", "34.204.63.21/32"]
}

resource "aws_wafv2_ip_set" "mainsite-stage-allow-prod-nginx-ip-set" {
  name               = "mainsite-stage-allow-prod-nginx-ip-set"
  description        = "IP set to whitelist Produciton Nginx IP addresses for Mainsite Stage ACL"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["52.13.209.160/32", "34.205.192.229/32", "52.11.75.34/32", "35.143.224.66/32", 
                        "35.172.62.29/32", "35.174.34.104/32", "34.207.38.254/32", "54.156.208.110/32", 
                        "52.87.180.57/32", "3.233.207.165/32", "3.81.245.224/32", "34.234.249.188/32", 
                        "52.39.77.81/32"]
}