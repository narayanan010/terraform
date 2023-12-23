#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider = "aws.route53_account"
  #name         = "capstage.net."
  name          = "${var.modulecaller_dns_r53_zone}"
  private_zone = false
}

module "cf_dist" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/cloudfront"
  source                         = "../../../../modules/cloudfront"
  name                           = "vp-frontend"
  stage                          = "staging"
  vertical                       = "capterra"
  cert_domain_name               = "vp-frontend.capstage.net"
  cert_hosted_zone_name          = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  source_region                  = "us-east-1"
  dest_region                    = "us-west-2"
  #cf_aliases                    = ["spa-test9.capstage.net"]
  #cf_forward_query_string
  #cf_minimum_protocol_version
  #cf_default_root_object
  #cf_viewer_protocol_policy
  #cf_price_class
  
  providers = {
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.dest = "aws.dest"
    aws.route53_account = "aws.route53_account"
  }
}