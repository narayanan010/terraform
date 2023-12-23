variable "modulecaller_source_region" {
  type        = string
  default     = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

variable "modulecaller_dns_r53_zone" {
  type        = string
  default     = "capstage.net."
  description = "Hosted Zone name Value to be passed via Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

variable "modulecaller_assume_role_primary_account" {
  type        = string
  default     = "arn:aws:iam::350125959894:role/gdm-dev-full_role"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets"
}

variable "modulecaller_assume_role_dns_account" {
  type        = string
  default     = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly)"
}


##Added below variables to support passing value from outside to module (Especially via Jenkins)

variable "cloudformationstackname" {
  type        = string
  description = "cloudformationstackname to be passed to module. Eg: capterra-crf-<PRNUMBER>-<ENV>"
}

variable "cert_domain_name" {
  type        = string
  description = "cert_domain_name to be passed to module. Eg: pr<PRNUMBER>.reviews.capstage.net"
}

variable "stage" {
  type        = string
  description = "stage to be passed to module. Eg: dev, staging etc"
  default     = "staging"
}

variable "primary_s3_bucket" {
  type        = string
  description = "Primary S3 Bucket name that CF distro S3 origin will point to. Eg: crf-<ENV>-<PRNUMBER>"
}

# Custom Tag
variable "tag_application" {
  type        = string
  description = "Tag for service application"
  default     = "crf"
}

