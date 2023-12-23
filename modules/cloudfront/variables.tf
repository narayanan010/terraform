variable "region_aws" {
	description = "This is region where tf template is to be deployed"
 	default     = "us-east-1"
}

variable "account_alias" {
    description = "This is account alias"
    default     = "capterra-sandbox"
}

variable "dest_region" {
    description = "This is region for secondary bucket"
    default = "us-west-2"
}

variable "source_region" {
    description = "This is region for primary bucket"
    default = "us-east-1"
}

variable "namespace" {
    type = "string"
    default = "gdm"
}

variable "name" {
    type = "string"
    description = "Name of application. E.g: cfr"    
}

variable "stage" {
    type = "string"
    description = "stage this resource belongs to (Dev/Prd/Stg/sandbox)"
} 

variable "vertical" {
    type = "string"
    description = "Vertical this resource belongs to (Capterra/GetApp/SoftwareAdvice)"
    default = "capterra"
}

variable "service" {
    type = "string"
    description = "AWS Service this resource will use"
    default = ""
}

variable "cf_forward_query_string" {
    default =   "false"
    description = "Forward query string to the origin that is associated with this cache behavior"
}

variable "cdn_max_ttl" {
    type = "string"
    default = "31536000"
}

variable "cdn_min_ttl" {
    type = "string"
    default = "0"
}

variable "cdn_default_ttl" {
    type = "string"
    default = "86400"
}

variable "custom_max_ttl" {
    type = "string"
    default = "31536000"
}

variable "custom_min_ttl" {
    type = "string"
    default = "0"
}

variable "custom_default_ttl" {
    type = "string"
    default = "86400"
}

variable "s3_path_pattern" {
    type = "string"
    default = "*"
}

variable "cf_minimum_protocol_version" {
    type = "string"
    description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, TLSv1.1_2016 or TLSv1.2_2018."
    default = "TLSv1.1_2016"
}

variable "cert_domain_name" {
    type = "string"
    description = "This is certificate domain that needs to be whitelisted. Format e.g spa-test.capstage.net"
}

variable cert_validation_type {
    description = "this is the type of cert validation to be used. Valid values are DNS, EMAIL"
    type = "string"
    default = "DNS"
}

variable "cert_hosted_zone_name" {
  description = "Name of the Hosted Zone where the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g capstage.net."
  type = "string"
}

variable "cf_default_root_object"{
    type = "string"
    description = "Default root object that CF Distro will point to."
    default = "index.html"
}

variable "cf_response_page_path"{
    type = "string"
    description = "cf_response_page_path CF distro's error pages section will point to."
    default = "/index.html"
}

variable "cf_error_caching_min_ttl" {
    type = "string"
    description = "cf_error_caching_min_ttl CF distro's error pages section will point to."
    default = "0"
}

variable "cf_response_code" {
    type = "string"
    description = "cf_response_code CF distro's error pages section will point to."
    default = "200"
}

variable "cf_aliases" {
  type        = list(string)
  description = "Other domain aliases to add to the CloudFront distribution other than main ones. Format to pass multiple aliases e.g: [alias-2,alias3] each in double quotes."
  default     = []
}

variable "cf_viewer_protocol_policy" {
    type = "string"
    description = "Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https."
    default = "allow-all"
}

variable "cf_price_class" {
    type = "string"
    description = "The price class for CF distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
    default = "PriceClass_All"
}

variable "r53_dns_ttl" {
    type = "string"
    description = "r53_dns_ttl is ttl for dns record"
    default = "90"
}

variable "cf_primary_bucket_index_doc" {
    type = "string"
    description = "cf_primary_bucket_index_doc is index document for Primary S3 Bucket"
    default = "index.html"
}

variable "cf_primary_bucket_error_doc" {
    type = "string"
    description = "cf_primary_bucket_error_doc is error document for Primary S3 Bucket"
    default = "error.html"
}

variable "cf_secondary_bucket_index_doc" {
    type = "string"
    description = "cf_secondary_bucket_index_doc is index document for Secondary S3 Bucket"
    default = "index.html"
}

variable "cf_secondary_bucket_error_doc" {
    type = "string"
    description = "cf_secondary_bucket_error_doc is error document for Secondary S3 Bucket"
    default = "error.html"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 Zone ID for DNS validation records"
}