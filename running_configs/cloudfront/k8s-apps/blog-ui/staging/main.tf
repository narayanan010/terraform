module "cloudfront_distribution" {
  source              = "../../../../../modules/Cloudfront_K8s_Apps/blog-ui"
  is_logging_enabled  = false
  acm_certificate_arn = var.acm_certificate_arn
  cname_aliases       = var.cname_aliases
  default_origin_dns  = var.default_origin_dns
  secret_header_value = var.secret_header_value
  web_acl_arn         = var.web_acl_arn
}

resource "aws_route53_record" "blog_ui" {
  for_each = toset(var.cname_aliases)
  zone_id  = var.hosted_zone_id
  name     = each.value

  type    = "A"

  alias {
    name                   = module.cloudfront_distribution.aws_cloudfront_distribution_dns
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

module "tags_resource_module" {
  source              = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"
  application         = "blog-ui"
  app_component       = "capterra"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "fabio.perrone@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "staging"
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "blog-ui"
  environment         = "staging"
}
