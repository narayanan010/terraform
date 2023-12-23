resource "aws_ec2_managed_prefix_list" "capterra_ue1_bastion_servers_internal_ips" {
  name           = "List of bastion servers internal ips "
  address_family = "IPv4"
  max_entries    = 10

  entry {
    cidr        = "10.114.54.89/32"
    description = "edbas1 us-east-1a"
  }

  entry {
    cidr        = "10.114.55.48/32"
    description = "edbas3 us-east-1b"
  }

  entry {
    cidr        = "10.114.54.190/32"
    description = "edbas4 us-east-1a main node"
  }

  entry {
    cidr        = "10.114.55.22/32"
    description = "edbas5 us-east-1b main node"
  }

  entry {
    cidr        = "10.114.60.103/32"
    description = "edbasw us-west-2 main node"
  }
}