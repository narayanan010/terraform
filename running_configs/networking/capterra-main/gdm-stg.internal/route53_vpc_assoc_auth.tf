#NOTE: This file was added later to this specific running-config to address VPC ID Authorizaiton from cross AWS Account (Search-Staging)
#Ref: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html

data "aws_vpc" "search-stage-vpc" {
    provider = aws.authorized_account
    id       = var.authorized_vpc_id
}

resource "aws_route53_vpc_association_authorization" "search-stage-vpc-authorization" {
    provider = aws
    vpc_id   = data.aws_vpc.search-stage-vpc.id
    zone_id  = var.zone_id
}

resource "aws_route53_zone_association" "search-stage-vpc-association" {
    provider = aws.authorized_account
    vpc_id   = data.aws_vpc.search-stage-vpc.id
    zone_id  = var.zone_id 
}