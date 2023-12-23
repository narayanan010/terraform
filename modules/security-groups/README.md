<!-- BEGIN_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Module for AWS Security Group.
This module is for creation of one or more AWS Security Groups.

Please make appropriate changes to the tfstate configuration to create Security Groups for each environment/project.

## What will this module do?
* Create AWS Security Groups based on CIDR, Source Security Group IDs and/or Self Referencing Security Groups.
* Ingress and Egress rules for Security Groups created.

## Usage:

When making use of this module:

  1. Define a variable for the role to be assumed and for the region in which you need to work:

    variable "modulecaller_source_region" {
      default     = "us-east-1"
      description = "Region to be passed to Provider info where calling module"
    }

    variable "modulecaller_assume_role_deployer_account" {
      default     = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
      description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
    }

  2. Reference those variables in your provider.tf:

    data "aws_caller_identity" "current" {}

    terraform {
      backend "s3" {}
      required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.13.0"
          }
      }
      required_version = ">= 1.1.5"
    }

    provider "aws" {
      region  = var.modulecaller_source_region
      assume_role {
        role_arn = var.modulecaller_assume_role_deployer_account
      }
    }

  3. Replace values of all the variables in the module as per requirement (default values provided wherever applicable).

## AWS Security Group - Example (Creation of inter-dependent Security Groups)
```
module "aws_sec_grp_module" {
  source                      = "../../../../modules/security-groups/"
  create_sg                   = true
  create_sg_ingress_cidr      = true
  create_sg_egress_cidr       = true
  sec_grp_names = [
    { name                    = "test-sec-grp-1"
      vpc_id                  = "vpc-fad17781"
      description             = "Test Security Group 1 for Sandbox" 
    }
  ]
  sg_ingress_rules_cidr = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 81, to_port = 81, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 82, to_port = 82, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = "" }
  ]
  sg_egress_rules_cidr = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = "" }
  ]
  providers = {
    aws = aws
  }
}

data aws_security_group "module1_sg" {
  name                        = "test-sec-grp-1"
  vpc_id                      = "vpc-fad17781"
  depends_on = [
    module.aws_sec_grp_module
  ]
}

module "aws_sec_grp2_module" {
  source                      = "../../../../modules/security-groups/"
  create_sg                   = true
  create_sg_ingress_source_sg = true
  create_sg_egress_source_sg  = true
  sec_grp_names = [
    { name = "test-sec-grp-2"
      vpc_id = "vpc-fad17781"
      description = "Test Security Group 2 for Sandbox" 
    }
  ]
  sg_ingress_rules_source_sg = [
    { from_port = 80, to_port = 80, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 81, to_port = 81, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 82, to_port = 82, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" },
    { from_port = 443, to_port = 443, protocol = "tcp", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" }
  ]
  sg_egress_rules_source_sg = [
    { from_port = 0, to_port = 0, protocol = "-1", source_sg_id = data.aws_security_group.module1_sg.id, ipv6_cidr_blocks = [], description = "" }
  ]
  providers = {
    aws = aws
  }
  depends_on = [
    module.aws_sec_grp_module
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sec_grp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.sg_egress_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_egress_rules_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_egress_rules_source_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_rules_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_rules_source_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_sg"></a> [create\_sg](#input\_create\_sg) | Boolean to check if Security Groups are to be created | `bool` | `false` | no |
| <a name="input_create_sg_egress_cidr"></a> [create\_sg\_egress\_cidr](#input\_create\_sg\_egress\_cidr) | Boolean to check if Security Group Egress CIDR rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_egress_self"></a> [create\_sg\_egress\_self](#input\_create\_sg\_egress\_self) | Boolean to check if Security Group Egress Self rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_egress_source_sg"></a> [create\_sg\_egress\_source\_sg](#input\_create\_sg\_egress\_source\_sg) | Boolean to check if Security Group Egress with Source Sec Grp ID rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_ingress_cidr"></a> [create\_sg\_ingress\_cidr](#input\_create\_sg\_ingress\_cidr) | Boolean to check if Security Group Ingress CIDR rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_ingress_self"></a> [create\_sg\_ingress\_self](#input\_create\_sg\_ingress\_self) | Boolean to check if Security Group Ingress Self rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_ingress_source_sg"></a> [create\_sg\_ingress\_source\_sg](#input\_create\_sg\_ingress\_source\_sg) | Boolean to check if Security Group Ingress with Source Sec Grp ID rules are to be created | `bool` | `false` | no |
| <a name="input_sec_grp_names"></a> [sec\_grp\_names](#input\_sec\_grp\_names) | Names of Security Groups to be created | <pre>list(object({<br>   name        = string<br>   vpc_id      = string<br>   description = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_egress_rules_cidr"></a> [sg\_egress\_rules\_cidr](#input\_sg\_egress\_rules\_cidr) | Egress Rule(s) for the Security Group | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    description      = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_egress_rules_self"></a> [sg\_egress\_rules\_self](#input\_sg\_egress\_rules\_self) | Egress Rule(s) for the Security Group | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    self        = bool<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_egress_rules_source_sg"></a> [sg\_egress\_rules\_source\_sg](#input\_sg\_egress\_rules\_source\_sg) | Egress Rule(s) for the Security Group | <pre>list(object({<br>    from_port    = number<br>    to_port      = number<br>    protocol     = string<br>    source_sg_id = string<br>    description  = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_cidr"></a> [sg\_ingress\_rules\_cidr](#input\_sg\_ingress\_rules\_cidr) | Ingress Rule(s) for the Security Group | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    description      = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_self"></a> [sg\_ingress\_rules\_self](#input\_sg\_ingress\_rules\_self) | Ingress Rule(s) for the Security Group | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    self        = bool<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_source_sg"></a> [sg\_ingress\_rules\_source\_sg](#input\_sg\_ingress\_rules\_source\_sg) | Ingress Rule(s) for the Security Group | <pre>list(object({<br>    from_port    = number<br>    to_port      = number<br>    protocol     = string<br>    source_sg_id = string<br>    description  = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sec_grp_arn"></a> [sec\_grp\_arn](#output\_sec\_grp\_arn) | This will provide the created Security Group ARNs |
| <a name="output_sec_grp_id"></a> [sec\_grp\_id](#output\_sec\_grp\_id) | This will provide the created Security Group IDs |
<!-- END_TF_DOCS -->