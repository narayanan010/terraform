terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"     
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
module "capterra-search-prd-deployer" {
    
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-prd"
    assumed_role_name           = "deployer"
    vertical                    = "capterra"  
    name                        = "deployer-search-prd"
}

module "capterra-search-prd-developer" {
   
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-prd"
    assumed_role_name           = "developer"
    vertical                    = "capterra"
    name                        = "developer-search-prd"   
}


module "prd_es_cluster" {
    source                      = "/Users/ctaras/repos/terraform-es"
    name                        =  "search"
    stage                       = "prd"
    vertical                    = "capterra"
    namespace                   = "capterra"
    cap_es_version              = "6.3"
    cap_es_instance_type        = "m4.large.elasticsearch"
    cap_es_instance_count       = "4"
    es_full_access_role         = ["${module.capterra-search-prd-deployer.role_arn}", "${module.capterra-search-prd-developer.role_arn}","${module.es_user.user_arn}"]
    es_log_arn_search_slow_logs = "${module.prd_es_cw_slow_search_log_group.arn}"
    es_log_arn_app_logs         = "${module.prd_es_cw_slow_app_group.arn}"
    es_log_arn_index_slow_logs  = "${module.prd_es_cw_slow_index_log_group.arn}"
}

module "prd_es_cw_slow_search_log_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "prd"
    vertical    =   "capterra"
    service     =   "es-search-slow-log"
}

module "prd_es_cw_slow_index_log_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "prd"
    vertical    =   "capterra"
    service     =   "es-index-slow-log"
}

module "prd_es_cw_slow_app_group" {
    source      =   "/Users/ctaras/repos/terraform-cw-log"
    name        =   "search"
    stage       =   "prd"
    vertical    =   "capterra"
    service     =   "es-index-app-log"
}

module "search_cf_dist" {
    source          = "/Users/ctaras/repos/terraform-cf"
    name            =   "search"
    stage           =   "prd"
    vertical        = "capterra"
    s3_path_pattern = "search/assets/*"
    cf_custom_origin_domain_name = "omp2mre4c9.execute-api.us-east-1.amazonaws.com"
    cf_asset_bucket              = "capterra-search-prd"
    cf_domain_name               = "search.capterra.com"
    cf_aliases                   = ["search.capterra.com"]
    r53_zone_name                = "capterra.com"
    cf_cname_record              = "search"
    cf_forward_query_string      = "true"
    cf_forward_header_values     = ["CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"]
    cf_custom_origin_path        = "prod"
}