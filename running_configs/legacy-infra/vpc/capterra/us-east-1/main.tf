resource "aws_subnet" "staging_public_1c"{
    vpc_id = "${var.vpc_id_staging}"
    cidr_block = "10.114.40.0/24"
    map_public_ip_on_launch = "true"
    availibility_zone = "us-east-1c" 
    tags = {
        ENVIRONMENT = "STAGING"
        Name = "pub-subnet-3-us-east-1c"
    }
}