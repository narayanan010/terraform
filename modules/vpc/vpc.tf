resource "aws_vpc" "this" {

    cidr_block                          = "${var.vpc_cidr_block}"
    enable_dns_hostnames                = "${var.vpc_enable_dns_hostnames}"
    enable_dns_support                  = "${var.vpc_enable_dns_support}"
    enable_classiclink                  = "${var.vpc_enable_classiclink}"
    enable_classiclink_dns_support      = "${var.vpc_enable_classiclink_dns_support}"    
    assign_generated_ipv6_cidr_block    = true
    tags {
        Name = "${var.stage}-${var.region}-${var.namespace}"
        terraform = "true"
        cidr = "${var.vpc_cidr_block}"
        environment = "${var.stage}"        
    } 
}

resource "aws_internet_gateway" "this" {
    vpc_id  =   "${aws_vpc.this.id}"
    
}

