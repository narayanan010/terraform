terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"     
  }  
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-east-1"
}

#Create Base Roles
module "capterra-search-dev-deployer" {
    
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-dev"
    assumed_role_name           = "deployer"
    vertical                    = "capterra"  
    name                        = "deployer-serch-dev"
}

module "capterra-search-dev-developer" {
   
    source                      = "git@github.com:capterra/terraform-role.git"
    assumed_account_alias       = "capterra-search-dev"
    assumed_role_name           = "developer"
    vertical                    = "capterra"
    name                        = "developer-search-dev"   
}


module "dev_es_cluster" {
    source                      = "git@github.com:capterra/terraform-es.git"
    name                        =  "search"
    stage                       = "dev"
    vertical                    = "capterra"
    namespace                   = "capterra"
    cap_es_version              = "6.3"
    es_full_access_role         = ["arn:aws:iam::148797279579:user/capterra-search-dev-es","${module.capterra-search-dev-deployer.role_arn}", "${module.capterra-search-dev-developer.role_arn}"]
    cap_es_instance_type        = "t2.medium.elasticsearch"
    es_log_arn_search_slow_logs = "${module.dev_es_cw_slow_search_log_group.arn}"
    es_log_arn_app_logs         = "${module.dev_es_cw_slow_app_group.arn}"
    es_log_arn_index_slow_logs  = "${module.dev_es_cw_slow_index_log_group.arn}"

}

module "dev_es_cw_slow_search_log_group" {
    source      =   "git@github.com:capterra/terraform-cw-log.git"
    name        =   "search"
    stage       =   "dev"
    vertical    =   "capterra"
    service     =   "es-search-slow-log"
}

module "dev_es_cw_slow_index_log_group" {
    source      =   "git@github.com:capterra/terraform-cw-log.git"
    name        =   "search"
    stage       =   "dev"
    vertical    =   "capterra"
    service     =   "es-index-slow-log"
}

module "dev_es_cw_slow_app_group" {
    source      =   "git@github.com:capterra/terraform-cw-log.git"
    name        =   "search"
    stage       =   "dev"
    vertical    =   "capterra"
    service     =   "es-index-app-log"
}

/*modle "search-dev-cloudfront" {
    source  = "/Users/ctaras/repos/terraform-cf"
    stage   = "dev"
    name    = "search"
    service = "cloudfront"
    cf_custom_origin_address    = "8jdb9cdvyd.execute-api.us-east-1.amazonaws.com"
    cf_aws_origin_bucket        = "capterra-search-service"
}
*/
