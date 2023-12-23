  resource "aws_route53_record" "all-capone" {
  for_each = toset(var.cname_aliases)
  zone_id  = var.hosted_zone_id
  name     = each.value
  type    = "A"
  ttl     = 600
  records = ["3.214.68.166","52.206.39.209"]
}

module "tags_resource_module" {
  source              = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"
  application         = "all-capone"
  app_component       = "capterra"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "suman.sindhu@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "staging"
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "all-capone"
  environment         = "staging"
}
