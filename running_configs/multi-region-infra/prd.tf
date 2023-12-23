module "aws_vpc_prd" {
    source                      = "git@github.com:capterra/terraform-vpc.git"
    vpc_cidr_block              = "10.114.56.0/21"
    vpc_private_subnet_count    = "3"    
    vpc_private_subnet_cidr     = ["10.114.56.0/24","10.114.57.0/24","10.114.58.0/24"]
    vpc_public_subnet_count     = "3"
    vpc_public_subnet_cidr      = ["10.114.60.0/24","10.114.59.0/24","10.114.61.0/24"]
    vpc_enable_dns_support      = "true"
    vpc_enable_classiclink      = "false"
    vpc_enable_dns_support      = "false"
    namespace                   = "capterrra"
    stage                       = "prd"
    region                      = "us-west-2"
}

#Create VPC peering connection. Note, since these are in different regions, we must accept the peering request in the AWS console manually.
resource "aws_vpc_peering_connection" "prd_west_2" {
    peer_owner_id                       = "${data.aws_caller_identity.current.account_id}"
    vpc_id                              = "${module.aws_vpc_prd.vpc_id}" 
    peer_vpc_id                         =  "vpc-c2ecc1a4"
    peer_region                         =  "us-east-1"        
    depends_on                          =  ["module.aws_vpc_prd"]
    tags     {
        Name                            =  "VPC-prd-us-w-2-us-e-1"
        stage                           =  "prd"
        vertical                        =  "capterra-dr"
    }
}

#Create route from US-West-2 to us-east-1"
resource "aws_route" "peer_route_pub" {
    count                       = "${length(module.aws_vpc_prd.vpc_public_route_table_id)}"
    route_table_id              = "${module.aws_vpc_prd.vpc_public_route_table_id[count.index]}"
    destination_cidr_block      = "10.114.24.0/21"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.prd_west_2.id}"
}

resource "aws_route" "peer_route_prv" {
    count                       = "${length(module.aws_vpc_prd.vpc_private_route_table_id)}"
    route_table_id              = "${module.aws_vpc_prd.vpc_private_route_table_id[count.index]}"
    destination_cidr_block      = "10.114.24.0/21"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.prd_west_2.id}"
}

#Create route from us-east-1 to us-west-2
resource "aws_route" "peer_route_pub1" {
    provider                    = "aws.capterra-east"
    route_table_id              = "rtb-e6611e9f"
    destination_cidr_block      = "10.114.56.0/21"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.prd_west_2.id}"
}

resource "aws_route" "peer_route_prv1" {
    provider                    = "aws.capterra-east"
    route_table_id              = "rtb-ad621dd4"
    destination_cidr_block      = "10.114.56.0/21"
    vpc_peering_connection_id   = "${aws_vpc_peering_connection.prd_west_2.id}"
}