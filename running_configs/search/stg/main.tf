terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"     
  }  
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-east-1"
}

provider "aws" {
    alias  = "capterra"
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"     
  }  
}

#Create Base Roles
module "capterra-search-stg-deployer" {
    
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-stg"
    assumed_role_name           = "deployer"
    vertical                    = "capterra"  
    name                        = "deployer"
}

module "capterra-search-stg-developer" {
   
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-stg"
    assumed_role_name           = "developer"
    vertical                    = "capterra"
    name                        = "developer"   
}


module "dev_es_cluster" {
    source                      = "/Users/ctaras/repos/terraform-es"
    name                        =  "search"
    stage                       = "stg"
    vertical                    = "capterra"
    namespace                   = "capterra"
    cap_es_version              = "6.3"
    cap_es_instance_type        = "t2.medium.elasticsearch"
    es_full_access_role         = ["${module.capterra-search-stg-deployer.role_arn}", "${module.capterra-search-stg-developer.role_arn}"]
    cap_es_instance_type        = "t2.medium.elasticsearch"
    es_log_arn_search_slow_logs = "${module.stg_es_cw_slow_search_log_group.arn}"
    es_log_arn_app_logs         = "${module.stg_es_cw_slow_app_group.arn}"
    es_log_arn_index_slow_logs  = "${module.stg_es_cw_slow_index_log_group.arn}"
}

module "stg_es_cw_slow_search_log_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "stg"
    vertical    =   "capterra"
    service     =   "es-search-slow-log"
}

module "stg_es_cw_slow_index_log_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "stg"
    vertical    =   "capterra"
    service     =   "es-index-slow-log"
}

module "stg_es_cw_slow_app_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "stg"
    vertical    =   "capterra"
    service     =   "es-index-app-log"
}

module "search_cf_dist" {
    source = "/Users/ctaras/repos/terraform-cf"
    name    =   "search"
    stage   =   "staging"
    vertical = "capterra"
    s3_path_pattern = "search/assets/*"
    cf_custom_origin_domain_name = "qwchwmov8d.execute-api.us-east-1.amazonaws.com"
    cf_asset_bucket      = "capterra-search-stg"
    cf_domain_name           = "search.capstage.net"
    cf_aliases               = ["search.capstage.net"]
    r53_zone_name            = "capstage.net"
    cf_cname_record          = "search"
    cf_forward_query_string  = "true"
    cf_forward_header_values = ["CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"]


}

module "scalyr_streaming_user" {
    source = "/Users/ctaras/repos/terraform-iam/iam-service-account"
    iam_user_name = "capterra-user-scalyr-streaming"
}

resource "aws_iam_user_policy_attachment" "this" {    
    user        =   "${module.scalyr_streaming_user.user_name}"
    policy_arn  =   "${module.search_cf_dist.scalyr_user_policy}"
}

