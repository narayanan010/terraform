# Bucket Variables and other vars.
variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "namespace" {
  type    = string
  default = "gdm"
}

variable "name" {
  type        = string
  description = "Name of application. E.g: user-workspace"
  default     = "user-workspace"
}

variable "stage" {
  type        = string
  description = "stage this resource belongs to (Dev/Prod/Stg/sandbox)"
  default     = "Stg"
}

variable "vertical" {
  type        = string
  description = "Vertical this resource belongs to (Capterra/GetApp/SoftwareAdvice)"
  default     = "capterra"
}

variable "cloudformationstackname" {
    type = string
    description = "Name of cloudformation Stack to grab Outputs from (API Gateway endpoint, S3 bucket etc). Eg: StackSet-SpotInstRoleDeployment-e6685df4-d2f7-46f3-b6aa-9c3c3d8636d9"
}

variable "cloudformation_stack_output_endpoint_variable" {
    type = string
    description = "This is the name output variable in existing Cloudformation Stack that holds the API Gateway Endpoint address. Eg: ServiceEndpoint"
    default = "ServiceEndpoint"
}

variable "prefix_api_gateway_endpoint" {
    type = string
    description = "prefix_api_gateway_endpoint. One of: https:// or http://"
    default = "https://"
}

variable "cf_primary_bucket_index_doc" {
  type        = string
  description = "cf_primary_bucket_index_doc is index document for Primary S3 Bucket"
  default     = "index.html"
}

variable "cf_primary_bucket_error_doc" {
  type        = string
  description = "cf_primary_bucket_error_doc is error document for Primary S3 Bucket"
  default     = "error.html"
}

variable "bucketName" {
  type        = string
  description = "Name of the existing S3 Bucket Eg- capterra-user-workspace-staging"
}

/*variable "origin_path" {
  type = string
  description = "path of the custom origin Eg- /staging"
}

variable "APIGatewayId" {
  type = string
  description = "ID of the API Gateway"
}*/

##Tags

#tags. These values can be overwritten when calling module.
variable "tag_application" {
  type    = string
  default = ""
}
variable "tag_app_component" {
  type    = string
  default = ""
}
variable "tag_function" {
  type    = string
  default = ""
}
variable "tag_business_unit" {
  type    = string
  default = ""
}
variable "tag_app_environment" {
  type    = string
  default = ""
}
variable "tag_app_contacts" {
  type    = string
  default = "opsteam@capterra.com"
}
variable "tag_created_by" {
  type    = string
  default = "fabio.perrone@gartner.com"
}
variable "tag_system_risk_class" {
  type    = string
  default = "3"
}
variable "tag_region" {
  type    = string
  default = ""
}
variable "tag_network_environment" {
  type    = string
  default = ""
}
variable "tag_monitoring" {
  type    = string
  default = ""
}
variable "tag_terraform_managed" {
  type    = string
  default = "true"
}
variable "tag_vertical" {
  type    = string
  default = ""
}
variable "tag_product" {
  type    = string
  default = ""
}
variable "tag_environment" {
  type    = string
  default = ""
}

variable "aws_cf_log_account_canonical_id" {
  type        = string
  description = "Canonical ID of Cloudfront AWS account"
  default     = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
}

# variable "primary_s3_bucket" {
#     type = string
#     description = "Primary S3 Bucket name that CF distro S3 origin will point to. EG: sa-ppl-form"
# }

# variable "primary_s3_bucket_domainsuffix" {
#     type = string
#     description = "Primary S3 Bucket domain suffix to append to s3 bucket name so that regional_domain_name can be constructed. Eg: s3.amazonaws.com"
#     default = "s3.amazonaws.com"
# }

# variable "primary_s3_bucket_arn_prefix" {
#     type = string
#     description = "Prefix to be added on Primary_S3_Bucket to construct arn so that is can be used in policy to allow access via OAI. Eg: arn:aws:s3:::"
#     default = "arn:aws:s3:::"
# }



#ACM Variables
variable "cert_domain_name" {
  type        = string
  description = "This is certificate domain that needs to be whitelisted. Format e.g sa-ppl-form-dr.capterra.com"
}

variable "cert_validation_type" {
  description = "this is the type of cert validation to be used. Valid values are DNS, EMAIL"
  type        = string
  default     = "DNS"
}

variable "cert_hosted_zone_name" {
  description = "Name of the Hosted Zone where the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g capstage.net."
  type        = string
}



#Cloudfront CDN variables

variable "cf_log_bucket_domain_name" {
  type        = string
  description = "The bucket to which logs are delivered from our distribution. E.g.: capterra-cloudfront-logs.s3.amazonaws.com"
  default     = "capterra-cloudfront-logs.s3.amazonaws.com"
}

variable "cf_minimum_protocol_version" {
  type        = string
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018."
  default     = "TLSv1.1_2016"
}

variable "cf_forward_query_string" {
  default     = "false"
  description = "Forward query string to the origin that is associated with this cache behavior"
}

variable "cf_forward_query_string_api" {
  default     = "true"
  description = "Forward query string to the origin that is associated with api cache behavior"
}

variable "cf_forward_header_values" {
  type        = list(any)
  description = "A list of whitelisted header values to send to origin server"
  default     = [""]
}

variable "cdn_max_ttl" {
  type    = string
  default = "0"
}

variable "cdn_min_ttl" {
  type    = string
  default = "0"
}

variable "cdn_default_ttl" {
  type    = string
  default = "0"
}

variable "custom_max_ttl" {
  type        = string
  description = "Max TTL for default_cache_behavior"
  default     = "0"
}

variable "custom_min_ttl" {
  type        = string
  description = "Min TTL for default_cache_behavior"
  default     = "0"
}

variable "custom_default_ttl" {
  type        = string
  description = "Default TTL for default_cache_behavior"
  default     = "0"
}


variable "cf_default_root_object" {
  type        = string
  description = "Default root object that CF Distro will point to."
  default     = "index.html"
}

variable "cf_response_page_path" {
  type        = string
  description = "cf_response_page_path CF distro's error pages section will point to."
  default     = "/workspace/index.html"
}

variable "cf_error_caching_min_ttl" {
  type        = string
  description = "cf_error_caching_min_ttl CF distro's error pages section will point to."
  default     = "0"
}

variable "cf_response_code" {
  type        = string
  description = "cf_response_code CF distro's error pages section will point to."
  default     = "200"
}

variable "cf_aliases" {
  type        = list(string)
  description = "Other domain aliases to add to the CloudFront distribution other than main ones. Format to pass multiple aliases e.g: [alias-2,alias3] each in double quotes."
  default     = []
}

variable "cf_viewer_protocol_policy" {
  type        = string
  description = "Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https."
  default     = "redirect-to-https"
}

variable "cf_price_class" {
  type        = string
  description = "The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  default     = "PriceClass_All"
}

variable "custom_origin_config_api-http_port" {
  type        = string
  description = "The HTTP port the custom origin listens on. HTTP Port for Custom API Gateway Origin for Cloudfront. Eg: 80"
  default     = "80"
}

variable "custom_origin_config_api-https_port" {
  type        = string
  description = "The HTTPS port the custom origin listens on. HTTPS Port for Custom API Gateway Origin for Cloudfront. Eg: 443"
  default     = "443"
}

variable "custom_origin_config_api-origin_protocol_policy" {
  type        = string
  description = "The origin protocol policy to apply to your origin. For Custom API Gateway Origin for Cloudfront. One of http-only, https-only, or match-viewer."
  default     = "https-only"
}

variable "custom_origin_config_api-origin_ssl_protocols" {
  type        = list(string)
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. For Custom API Gateway Origin for Cloudfront. A list of one or more of [SSLv3, TLSv1, TLSv1.1, TLSv1.2]."
  default     = ["TLSv1"]
}

variable "custom_origin_config_api-origin_keepalive_timeout" {
  type        = string
  description = "For API Gateway Custom Origin. The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60."
  default     = "5"
}

variable "custom_origin_config_api-origin_read_timeout" {
  type        = string
  description = "For API Gateway Custom Origin. The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60."
  default     = "30"
}

variable "ordered_cache_behavior_default_ttl" {
  type        = string
  description = "The default_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "31536000"
}

variable "ordered_cache_behavior_min_ttl" {
  type        = string
  description = "The min_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "31536000"
}

variable "ordered_cache_behavior_max_ttl" {
  type        = string
  description = "The max_ttl for the Ordered Cache Behavior. Eg: 31536000"
  default     = "31536000"
}

variable "ordered_cache_behavior_viewer_protocol_policy" {
  type        = string
  description = "Viewer Protocol policy for ordered cache behavior. Valid values are One of: allow-all, https-only, or redirect-to-https."
  default     = "redirect-to-https"
}

variable "modulecaller_assume_role_primary_account" {
  default     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets"
}

variable "wafID" {
  type        = string
  description = "ARN of the WAF WebACL to associate with the Distribution"
}

variable "cloudformation_stack_output_endpoint_variable_GraphQL" {
    type = string
    description = "This is the name output variable in existing Cloudformation Stack that holds the GraphQl Api Url. Eg: GraphQlApiUrl"
    default = "GraphQlApiUrl"
}

#R53 Variables

variable "r53_dns_ttl" {
    type = string
    description = "r53_dns_ttl is ttl for dns record"
    default = "90"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 Zone ID for DNS validation records"
}
