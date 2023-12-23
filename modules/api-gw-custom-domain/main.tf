# This module is for creation of API GW custom domain name
# This module should:
  ## Get the value of API Gateway endpoints and other related information from CloudFormation templates.
  ## 
  ## 
  ##  Create API GW Custom Domain:-
      ### Pointing to API Gateway Endpoint
  ## Create DNS record in appropriate Hosted zone to point to the Custom Domain Name created.

#*************************************************************************************************************************************************************#
#                                                                     PROVIDER DATA                                                                           #
#*************************************************************************************************************************************************************#
#Moving provider info from provider.tf to main.tf
provider "aws" {
   alias =  "primary_cf_account"
   #region = var.region_aws
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 }

provider "aws" {
  alias = "route53_account"
  #region = var.region_aws
  #Uncomment below to test module while development
  #assume_role {
  #Below Role is Capterra account Role. This can be replaced with any assume Role info
  #     role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/assume-capterra-admin-batch"
  #}
}

 #provider "aws" {
   #alias =  "dest"
   #region = "${var.dest_region}"
   #Uncomment below to test module while development
   #assume_role {
   #Below Role is Sandbox account Role. This can be replaced with any assume Role info
   #  role_arn     = "arn:aws:iam::xxxxxxxxxxxx:role/no-color-staging-admin"
   #}
 #}

 #This is needed, as the latest providers have bug and continue prompting for region even though defined under specific alias. https://github.com/terraform-providers/terraform-provider-aws/issues/9989
 #provider "aws" {
   #region = var.region_aws
 #}


#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


#*************************************************************************************************************************************************************#
#                                                              API GATEWAY DOMAIN SECTION                                                                     #
#*************************************************************************************************************************************************************#

resource "aws_api_gateway_domain_name" "apgdn" {
  provider = aws.primary_cf_account
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
  domain_name     = var.apigw_custom_domain_name
  endpoint_configuration {
    types = ["${var.apgdn_types}"]
  }
  tags = "${merge(module.tags_resource_module.tags,map("Environment", "${var.stage}"))}"
  security_policy = var.apigw_security_policy
}


#*************************************************************************************************************************************************************#
#                                                              API GATEWAY BASE PATH MAPPING                                                                  #
#*************************************************************************************************************************************************************#

resource "aws_api_gateway_base_path_mapping" "apigwbpm" {
  provider = aws.primary_cf_account
  api_id      = var.api_id
  stage_name  = var.api_stage_name
  domain_name = aws_api_gateway_domain_name.apgdn.domain_name
}


#*************************************************************************************************************************************************************#
#                                                         ACM CERTIFICATE SECTION WITH VALIDATION INCLUDED                                                    #
#*************************************************************************************************************************************************************#
#Note: This section will use multiple provider info. Because ACM cert accounts and R53 Hosted Zone accounts can be different AWS Accounts. Use valid Providers.


#This section will create acm certificate in the account that will host Cloudfront distribution. This has to run in the account that will host CF Distro.
#Use Valid provider.
resource "aws_acm_certificate" "cert" {
  provider = aws.primary_cf_account
  domain_name       = var.apigw_custom_domain_name
  validation_method = var.cert_validation_type

  tags = {
    Name              = var.apigw_custom_domain_name
    terraform_managed = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#This section will fetch info needed for Creation of CNAME record for DNS validation required for acm certificate. This has to run in the account that hosts R53 Hosted-Zone. Use valid Provider.
#While testing the module from here, below data "aws_route53_zone" worked fine. But while calling module from outside resulted in error that "NoR53 Zone found". Hence data section has to be moved to outside resource manifest that calls module. Reference : https://issue.life/questions/41631966 . Hence commenting below section. To test module locally uncomment.
#data "aws_route53_zone" "zone" {
#  provider = aws.route53_account
#  #name         = "capstage.net."
#  name          = var.cert_hosted_zone_name
#  private_zone = false
#}

#This section will create CNAME record for Cert Validation in the account that hosts R53 Hosted-Zone. This has to run in the account that hosts R53 Zone. Use Valid provider.
resource "aws_route53_record" "cert_validation" {
  provider = "aws.route53_account"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  #zone_id = "${data.aws_route53_zone.zone.id}"
  zone_id = var.hosted_zone_id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

#This section will wait for DNS Validation to be successful. This has to run in the account that hosts ACM and CF Distro. Use Valid provider.
resource "aws_acm_certificate_validation" "cert" {
  provider = aws.primary_cf_account
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}


#*************************************************************************************************************************************************************#
#                                         AWS R53 SECTION TO ADD CNAME RECORD FOR WEBSITE WITH CF DOMAIN AS DESTINATION                                       #
#*************************************************************************************************************************************************************#

#This section will add the r53 record for website hosting into the hosted zone. This will use the provider info from account that hosts Hosted Zone. Use Valid Provider.

resource "aws_route53_record" "dns_record" {
  provider  =   aws.route53_account
  name      = aws_api_gateway_domain_name.apgdn.domain_name
  type      = "CNAME"
  zone_id   = var.hosted_zone_id
  ttl       =   "${var.r53_dns_ttl}"
  records   =   ["${aws_api_gateway_domain_name.apgdn.cloudfront_domain_name}"]
}

#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/tagging-resource-module"
  #source                         = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"
  source                         = "../tagging-resource-module"
  application                    = var.tag_application
  app_component                  = var.tag_app_component
  function                       = var.tag_function
  business_unit                  = var.tag_business_unit
  app_environment                = var.tag_app_environment
  app_contacts                   = var.tag_app_contacts
  created_by                     = var.tag_created_by
  system_risk_class              = var.tag_system_risk_class
  region                         = var.tag_region
  network_environment            = var.tag_network_environment             
  monitoring                     = var.tag_monitoring
  terraform_managed              = var.tag_terraform_managed
  vertical                       = var.tag_vertical
  product                        = var.tag_product
  environment                    = var.tag_environment

  #Add Other tags here that you want to apply to all resources, those are to be added to the resources apart from standard tags from Gartner/Capterra.
  tags = {
    #"Business"     = "tech",
    #"Snapshot"     = "false"
  }
}