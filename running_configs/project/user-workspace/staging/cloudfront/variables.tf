# variable "modulecaller_source_region" {
#   default     = "us-east-1"
#   description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
# }

# variable "modulecaller_source_region_ue1" {
#   default     = "us-east-1"
#   description = "Region ue1 as cf can only use certs from us-east-1"
# }

variable "region" {
  default     = "us-east-1"
  description = "Default Region"
}

variable "modulecaller_dns_r53_zone" {
  default     = "capstage.net."
  description = "Hosted Zone name Value to be passed via Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

/*variable "modulecaller_api_gateway" {
  default     = "user-workspace-staging"
  description = "CloudFormation Stack Name to read the Service end point of API Gateway"
}*/

# variable "modulecaller_assume_role_primary_account" {
#   default     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
#   description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets"
# }

# variable "modulecaller_assume_role_dns_account" {
#   default     = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
#   description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly)"
# }


##Added below variables to support passing value from outside to module (Especially via Jenkins)

variable "cert_domain_name" {
  description = "cert_domain_name to be passed to module. Eg: user-workspace.capstage.net"
  default     = "user-workspace.capstage.net"
}

variable "stage" {
  description = "stage to be passed to module. Eg: dev, staging, prod etc"
  default     = "staging"
}

/*variable "primary_s3_bucket" {
  type        = string
  description = "Primary S3 Bucket name that CF distro S3 origin will point to. Eg: user-workspace-stage"
  default     = "user-workspace-stage"
}*/
