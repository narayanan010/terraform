# Cloudfront module for Serverless-Apps for Capterra.
    This module is for creating CF distro for capterra-User-Workspace in Capterra.
    This module is forked from Capterra in-house TF module for "Cloudfront_Serverless_Apps". This is modified specifically for capterra-user-workspace requirements.
    
#### What this module will do?
  ```
  # Create Amazon certificate (ACM).
  # Will wait for ACM certificate to wait for to get to issued Status
  # Create Cloudfront Distribution with:-
      Error page redirecting 404 and 403 errors to index.html
      Automatically adds cert_domain_name to cloudfront alias.
      Creates 2 separate origins, One pointing to s3 bucket passed via primary_s3_bucket variable. And another pointing to API Gateway Endpoint deduced from Cloudformation Stack. The name of Cloudformation stack should passed via `cloudformationstackname` variable. And the variable that stores endpoint must be passed via `cloudformation_stack_output_endpoint_variable`.
  # Create DNS record in appropriate Hosted zone to point to the cloudfront distribution created above. Pass Hosted zone using var: `cert_hosted_zone_name`
  # Note: 
        * This module will accept single domain name for ACM cert. subject_alternative_names aren't supported due to current issue witn provider mentioned here: https://github.com/terraform-providers/terraform-provider-aws/issues/8531 . Future versions of module will support this functionality if needed.
        * In 'default_cache_behavior' section in module, Uncomment the <headers> section to add the list of whitelisted headers to default cache behavior under <Cache Based on Selected Request Headers: Whitelist> value in Cloudfront. And pass list of headers via variable "cf_forward_header_values" while calling module. Or else <Cache Based on Selected Request Headers: None> is set with no whitelisted headers.
        * For API-Gateway Origin in Cloudfront, Module expects the Cloudformation Stack output Variable's value in format as: https://{url}/{api-stage} ; in order to deduce domain_name and origin_path automatically for Cloudfront. Eg: https://iqaedf32r4.execute-api.us-east-1.amazonaws.com/sandbox. Default Cloudformation o/p variable where the value is picked from is "ServiceEndpoint". When calling module Custom Variables can also be passed if some other variable in Cloudformation holds the API Gateway endpoint. 
```
&nbsp;
#### Module Imports
All Cloudfront distribution created with this module will use shared components previouly deployed in 
`./common` folder

  - 1 x Origin Access Control (OAC)
  - 3 x Cloudfront cache policies

Create or destroy some distribution does not affect common componets deployed in another Terraform STATE

&nbsp;
### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account, 
        var.modulecaller_assume_role_dns_account
  3. Optionally backend section can be moved to separate backend.tf in caller terraform file. Or Keep it as is in below.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly
  7. data "aws_route53_zone" "zone" {} section is included below, as this is needed to automatically deduce the zone_id required for CNAME record insertion in the hosted_zone during ACM validation via DNS method, and during the final CNAME creation that points to Created Cloudfront Domain. Keep it as is.

&nbsp;

### Inputs from module:

The variables that are passed to module internally. These can be overwritten when calling module from outside. These are:

|Module Parameter|Type|Required|Default Value|Valid Values|Description|
|-|-|-|-|-|-
|region_aws|string|YES|`us-east-1`|`AWS values`|This is region where module is to be deployed
|namespace|string|YES|`gdm`|`any`|This will be used in naming of resources created
|cloudformationstackname|string|YES|`null`|`any`|Cloudformation stack name that will hold the API Gateway Url Endpoint.
|cloudformation_stack_output_endpoint_variable|string|YES|`ServiceEndpoint`|`AWS values`|Variable that hold the API Gateway endpoint in cloudformation stack.
|s3_path_pattern|string|YES|`null`|`any/any`|The Path Pattern for the Ordered Cache Behavior. Eg: search/assets/test/*
|cert_hosted_zone_name|string|YES|`null`|`any`|Name of the Hosted Zone under which the CNAME Record has to be created for DNS Validation of ACM Cert. Notice the dot at the end of format example. Format e.g "capstage.net." or "capterra.com." etc.
|hosted_zone_id|string|YES|`null`|`any`|Route 53 hosted zone_id for domain_name. This is automatically calculated via Datasource present in caller of module.
|cert_domain_name|string|YES|`any`|`any`|This is certificate domain that needs to be whitelisted. Also used for the Name tag of the ACM certificate. This will also be added to CNAME alias in cloudfront automatically.  Format e.g serverlessapp1-test.capstage.net
|r53_dns_ttl|string|YES|`60`|`integer`|Route 53 record time-to-live (TTL) for validation record.
|cf_forward_query_string|string|YES|`any`|`any`|Forward query string to the origin that is associated with s3 cache behavior. 
|cf_minimum_protocol_version|string|YES|`TLSv1.2_2021`|`[TLSv1 / TLSv1_2016 / TLSv1.1_2016 / TLSv1.2_2018 / TLSv1.2_2021]`|The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can only be set if cloudfront_default_certificate = false
|cf_default_root_object|string|YES|`index.html`|`any`|Default root object that CF Distro will point to.
|cf_viewer_protocol_policy|string|YES|`us-east-1`|`[allow-all / https-only / redirect-to-https]`|Viewer Protocol policy for behavior. Valid values are One of: allow-all, https-only, or redirect-to-https.
|cf_price_class|string|YES|`PriceClass_All`|`[PriceClass_All / PriceClass_200 / PriceClass_100]`|The price class for CF distribution.
|cloudformationstackname|string|YES|`null`|`any`|Cloudformation stack name that will hold the API Gateway Url Endpoint.
|prefix_api_gateway_endpoint|string|YES|`https://`|`[https:// / http://]`|prefix_api_gateway_endpoint is Prefix of API Gateway URL. This value is trimmed to get the endpoint for CF origin.
|aws_cf_log_account_canonical_id|string|YES|`c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0`|`any`|This is `awslogsdelivery` access for CF logging to S3 bucket.
|primary_s3_bucket|string|YES|`null`|`any`|Primary S3 Bucket name that CF distro S3 origin will point to.
|primary_s3_bucket_domainsuffix|string|YES|`s3.amazonaws.com`|`any`|Primary S3 Bucket domain suffix to append to s3 bucket name so that regional_domain_name can be constructed.
|primary_s3_bucket_arn_prefix|string|YES|`arn:aws:s3:::`|`any`|Prefix to be added on Primary_S3_Bucket to construct arn so that is can be used in policy to allow access via OAI.
|cf_forward_query_string_api|string|YES|`true`|`[true / false]`|Forward query string to the origin that is associated with api cache behavior.
|custom_default_ttl|string|YES|`86400`|`any`|Default TTL for default_cache_behavior (s3)
|custom_max_ttl|string|YES|`31536000`|`any`|Max TTL for default_cache_behavior
|custom_min_ttl|string|YES|`0`|`any`|Min TTL for default_cache_behavior
|ordered_cache_behavior_default_ttl|string|YES|`31536000`|`any`|Default TTL for ordered_cache_behavior (api)
|ordered_cache_behavior_max_ttl|string|YES|`31536000`|`any`|Max TTL for ordered_cache_behavior
|ordered_cache_behavior_min_ttl|string|YES|`31536000`|`any`|Min TTL for ordered_cache_behavior
|cf_response_page_path|string|YES|`/workspace/index.html`|`AWS values`|cf_response_page_path CF distro's error pages section will point to.
|cf_error_caching_min_ttl|string|YES|`0`|`any`|cf_error_caching_min_ttl CF distro's error pages section will point to.
|cf_response_code|string|YES|`200`|`any`|cf_response_code CF distro's error pages section will point to.
|custom_origin_config_api-http_port|string|YES|`80`|`AWS values`|This is for Custom Origin Config. The HTTP port the custom origin listens on. HTTP Port for Custom API Gateway Origin for Cloudfront.
|custom_origin_config_api-https_port|string|YES|`443`|`any`|This is for Custom Origin Config. The HTTPS port the custom origin listens on. HTTPS Port for Custom API Gateway Origin for Cloudfront.
|custom_origin_config_api-origin_protocol_policy|string|YES|`https-only`|`any`|This is for Custom Origin Config. The origin protocol policy to apply to your origin. For Custom API Gateway Origin for Cloudfront. One of http-only, https-only, or match-viewer.
|custom_origin_config_api-origin_ssl_protocols|string|YES|`TLSv1`|`[SSLv3 / TLSv1 / TLSv1.1 / TLSv1.2]`|This is for Custom Origin Config. The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. For Custom API Gateway Origin for Cloudfront. A list of one or more of [SSLv3, TLSv1, TLSv1.1, TLSv1.2].
|custom_origin_config_api-origin_keepalive_timeout|string|YES|`[5-60]`|`any`|For API Gateway Custom Origin. The Custom KeepAlive timeout, in seconds.
|custom_origin_config_api-origin_read_timeout|string|YES|`30`|`[5-60]`|For API Gateway Custom Origin. The Custom Read timeout, in seconds.
|ordered_cache_behavior_viewer_protocol_policy|string|YES|`redirect-to-https`|`[allow-all / https-only /  redirect-to-https]`|Viewer Protocol policy for ordered cache behavior. Valid values are One of: allow-all, https-only, or redirect-to-https.
|cf_forward_header_values|list|YES|`[""]`|`list(any)`|A list of whitelisted header values to send to origin server for default_cache_behavior. Sample eg: ["CloudFront-Is-Desktop-Viewer", "Cloudfront-Is-Mobile-Viewer", "Cloudfront-Is-Tablet-Viewer", "Cloudfront-Viewer-Country"] etc. Refer top of readme for more details under Note section.
|cache_policy_redirect_lambda|string|YES|`null`|`any`|The common Cloudfront cache policy for lambdas
|cache_policy_standard |string|YES|`null`|`any`|The common Cloudfront cache policy standard
|cache_policy_default|string|YES|`null`|`any`|The common Cloudfront cache policy defautl
|cf_origin_access_control|string|YES|`null`|`any`|The common Cloudfront Origin Access Control (OAC)

&nbsp;

### Outputs from module: 
Below outputs can be exported from module:

- `aws_acm_certificate_arn` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless Apps
- `cloudfront_distro_id` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - The ID of Cloudfront distribution just created for Serverless App
- `cloudfront_distro_arn` &nbsp;&nbsp;&nbsp;&nbsp; - The ARN of Cloudfront distribution just created for Serverless App
- `cloudfront_distro_domain_name` &nbsp;&nbsp;&nbsp; - The domain_name of Cloudfront distribution just created for Serverless App
- `r53_dns_domain_name` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - The name of DNS record just created for Serverless App
&nbsp;


&nbsp;
## Sections to be added to module caller's main.tf below:

#### Include Below section to caller's main.tf


```
module "cf_dist_serverless" {
  source                                        = "../cloudfront_serverless_module-user-workspace"
  name                                          = "capterra-user-workspace"
  stage                                         = var.stage
  vertical                                      = "capterra"
  cloudformationstackname                       = var.cloudformationstackname
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  cert_domain_name                              = var.cert_domain_name
  cert_hosted_zone_name                         = "capstage.net."
  hosted_zone_id                                = data.aws_route53_zone.zone.zone_id
  region_aws                                    = "us-east-1"
  primary_s3_bucket                             = var.primary_s3_bucket
  s3_path_pattern                               = "_next/static/*"
  custom_max_ttl                                = "0"
  custom_min_ttl                                = "0"
  custom_default_ttl                            = "0"
  cf_forward_header_values                      = ["Referer", "Nginx_GeoIp_Country_Code"]
  cache_policy_redirect_lambda                  = data.terraform_remote_state.common_resources.outputs.cache_policy_redirect_lambda.id
  cache_policy_standard                         = data.terraform_remote_state.common_resources.outputs.cache_policy_standard.id
  cache_policy_default                          = data.terraform_remote_state.common_resources.outputs.cache_policy_default.id
  cf_origin_access_control                      = data.terraform_remote_state.common_resources.outputs.aws_cloudfront_origin_access_control.id


  providers = {
    aws.primary_cf_account = aws.primary_cf_account
    aws.route53_account    = aws.route53_account
  }
}
```
&nbsp;
