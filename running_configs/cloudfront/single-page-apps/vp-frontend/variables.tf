 variable "modulecaller_source_region" {
  default = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

  variable "modulecaller_dest_region" {
  default = "us-west-2"
  description = "Region of Secondary Bucket that needs to be passed to Provider info where calling module"
}

  variable "modulecaller_dns_r53_zone" {
  default = "capstage.net."
  description = "Hosted Zone name Value to be passed to Data Source to get the zone_id. zone_id is used while inserting DNS records for cert validation and for Final CNAME addition to R53"
}

  variable "modulecaller_assume_role_primary_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets. Replace this value per need."
}

  variable "modulecaller_assume_role_dns_account" {
  default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly). Replace this per need."
} 