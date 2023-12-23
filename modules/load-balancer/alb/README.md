<!-- BEGIN_TF_DOCS -->
# Module for Application Load Balancer (ALB).
This module is for creating an AWS Application Load Balancer.

Please make appropriate changes to the tfstate configuration to create ALB resources for each environment/project.

## What will this module do?
* Create an AWS Application Load Balancer (aws_alb.alb).
* Create HTTP Listener(s) if the corresponding required rules for the resource(s) are provided as inputs.
* Create HTTPS Listener if the corresponding required rules for the resource are provided as inputs.
* Create Target Groups to be associated with the Listeners created previously, using the target_group_index attribute.
* Create Target Group attachments which will allow multiple Targets to be associated with the Target Groups created.
* Create a new Security Group dedicatedly attached with the Application Load Balancer.
* Create a new Self Referential Security Group rule and attach with the ALB Security Group, controlled using a Boolean variable.

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

## Application Load Balancer - Example
```
module "aws_lb_module" {

  source          = "../../../../../modules/load-balancer/alb/"

  ec2_subnets     = ["subnet-0c92174c89cf6d257","subnet-31f2a81e"]

  bucket_name     = "capterra-loadbalancer-logs"

  alb_sg_name     = "alb_sg"

  alb_name        = "alb-internal-sandbox"

  vpc_id          = "vpc-fad17781"

  waf_acl         = true

  waf_acl_name    = "FMManagedWebACLV2-AWS_FMS_ShieldAdvancedRule-1655501154300"

  waf_acl_scope   = "REGIONAL"

  acm_data_block  = true

  acm_domain      = "foobar.capstage.net"

  sg_ingress_rules_cidr = [
    {from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = ""},
    {from_port = 81, to_port = 81, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = ""},
    {from_port = 82, to_port = 82, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = ""},
    {from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["172.31.0.0/16", "10.114.0.0/16"], ipv6_cidr_blocks = [], description = ""}
  ]

  create_sg_ingress_source_sg = true

  sg_ingress_rules_source_sg = [
    {from_port = 8080, to_port = 8080, protocol = "tcp", source_sg_id = "sg-0d84e013f4d2b5d2e", description = ""}
  ]

  sg_egress_rules_cidr = [
    {from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = [], description = ""}
  ]

  internal = true

  lb_logs = {
    bucket  = "capterra-loadbalancer-logs"
    enabled = true
    prefix  = "alb-internal-sandbox"
  }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port        = 81
      protocol    = "HTTP"
      target_group_index = 1
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
    {
      port        = 82
      protocol    = "HTTP"
      target_group_index = 2
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "200"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 3
      action_type        = "forward"

    }
  ]

  target_groups = [
    {
      name                 = "alb-tg-1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.174"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.24"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-2"
      backend_protocol     = "HTTP"
      backend_port         = 81
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.172"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.22"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-3"
      backend_protocol     = "HTTP"
      backend_port         = 82
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index2.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.176"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.26"
          availability_zone = "all"
          port              = 8080
        }
      }
    },
    {
      name                 = "alb-tg-4"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index3.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        my_ec2 = {
          target_id = "172.31.109.178"
          port      = 80
        },
        my_ec2_again = {
          target_id         = "10.114.7.28"
          availability_zone = "all"
          port              = 8080
        }
      }
    }
  ]

  providers = {
      aws = aws
  }
}
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.frontend_http_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.frontend_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.alb-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_alb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group_attachment) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.sg_egress_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_egress_rules_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_egress_rules_source_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_rules_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_ingress_rules_source_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_wafv2_web_acl_association.alb_waf_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_acm_certificate.acm_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_wafv2_web_acl.alb_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/wafv2_web_acl) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_data_block"></a> [acm\_data\_block](#input\_acm\_data\_block) | Boolean to decide whether ACM Data block is needed to fetch the ACM Cert ARN for HTTPS Listener | `bool` | `false` | no |
| <a name="input_acm_domain"></a> [acm\_domain](#input\_acm\_domain) | Domain name required to fetch the appropriate ACM Certificate to be attached to the HTTPS Listener | `string` | `""` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Application Load Balancer name | `string` | n/a | yes |
| <a name="input_alb_sg_name"></a> [alb\_sg\_name](#input\_alb\_sg\_name) | ALB Security Group name | `string` | n/a | yes |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Controls if the Load Balancer should be created or not | `bool` | `true` | no |
| <a name="input_create_sg"></a> [create\_sg](#input\_create\_sg) | Boolean to check if Security group is to be created | `bool` | `true` | no |
| <a name="input_create_sg_egress_cidr"></a> [create\_sg\_egress\_cidr](#input\_create\_sg\_egress\_cidr) | Boolean to check if Security Group Egress CIDR rules are to be created | `bool` | `true` | no |
| <a name="input_create_sg_egress_self"></a> [create\_sg\_egress\_self](#input\_create\_sg\_egress\_self) | Boolean to check if Security Group Egress Self rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_egress_source_sg"></a> [create\_sg\_egress\_source\_sg](#input\_create\_sg\_egress\_source\_sg) | Boolean to check if Security Group Egress with Source Sec Grp ID rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_ingress_cidr"></a> [create\_sg\_ingress\_cidr](#input\_create\_sg\_ingress\_cidr) | Boolean to check if Security Group Ingress CIDR rules are to be created | `bool` | `true` | no |
| <a name="input_create_sg_ingress_self"></a> [create\_sg\_ingress\_self](#input\_create\_sg\_ingress\_self) | Boolean to check if Security Group Ingress Self rules are to be created | `bool` | `false` | no |
| <a name="input_create_sg_ingress_source_sg"></a> [create\_sg\_ingress\_source\_sg](#input\_create\_sg\_ingress\_source\_sg) | Boolean to check if Security Group Ingress with Source Sec Grp ID rules are to be created | `bool` | `false` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. | `string` | `"defensive"` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `false` | no |
| <a name="input_ec2_subnets"></a> [ec2\_subnets](#input\_ec2\_subnets) | Subnets to use for the Load Balancer | `list(any)` | n/a | yes |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Indicates whether cross zone load balancing should be enabled in application load balancers. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. | `bool` | `true` | no |
| <a name="input_enable_waf_fail_open"></a> [enable\_waf\_fail\_open](#input\_enable\_waf\_fail\_open) | Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF | `bool` | `false` | no |
| <a name="input_http_tcp_listeners"></a> [http\_tcp\_listeners](#input\_http\_tcp\_listeners) | A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target\_group\_index (defaults to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_https_listeners"></a> [https\_listeners](#input\_https\_listeners) | A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate\_arn. Optional key/values: ssl\_policy (defaults to ELBSecurityPolicy-2016-08), target\_group\_index (defaults to https\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean determining if the load balancer is internal or externally facing. | `bool` | `true` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| <a name="input_lb_logs"></a> [lb\_logs](#input\_lb\_logs) | Map containing access logging configuration for load balancer. | `map(string)` | `{}` | no |
| <a name="input_listener_ssl_policy_default"></a> [listener\_ssl\_policy\_default](#input\_listener\_ssl\_policy\_default) | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are application or network. | `string` | `"application"` | no |
| <a name="input_sg_egress_rules_cidr"></a> [sg\_egress\_rules\_cidr](#input\_sg\_egress\_rules\_cidr) | Egress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    description      = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_egress_rules_self"></a> [sg\_egress\_rules\_self](#input\_sg\_egress\_rules\_self) | Egress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    self        = bool<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_egress_rules_source_sg"></a> [sg\_egress\_rules\_source\_sg](#input\_sg\_egress\_rules\_source\_sg) | Egress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port    = number<br>    to_port      = number<br>    protocol     = string<br>    source_sg_id = string<br>    description  = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_cidr"></a> [sg\_ingress\_rules\_cidr](#input\_sg\_ingress\_rules\_cidr) | Ingress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>    description      = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_self"></a> [sg\_ingress\_rules\_self](#input\_sg\_ingress\_rules\_self) | Ingress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    self        = bool<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_sg_ingress_rules_source_sg"></a> [sg\_ingress\_rules\_source\_sg](#input\_sg\_ingress\_rules\_source\_sg) | Ingress Rule(s) for the Security Group associated with the Application Load Balancer | <pre>list(object({<br>    from_port    = number<br>    to_port      = number<br>    protocol     = string<br>    source_sg_id = string<br>    description  = string<br>  }))</pre> | `[]` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the Security Group to be created and attached with the Load Balancer | `string` | n/a | yes |
| <a name="input_waf_acl"></a> [waf\_acl](#input\_waf\_acl) | Boolean to decide if WAF ACL association is needed for the Load Balancer or not | `bool` | `false` | no |
| <a name="input_waf_acl_name"></a> [waf\_acl\_name](#input\_waf\_acl\_name) | WAF ACL Name to be associated with the Load Balancer | `string` | `""` | no |
| <a name="input_waf_acl_region"></a> [waf\_acl\_region](#input\_waf\_acl\_region) | WAF ACL Region needed only when WAF\_ACL\_SCOPE is set to `CLOUDFRONT` | `string` | `""` | no |
| <a name="input_waf_acl_scope"></a> [waf\_acl\_scope](#input\_waf\_acl\_scope) | WAF ACL Scope, with possible values of REGIONAL or CLOUDFRONT | `string` | `""` | no |
| <a name="input_dd_alerts_to"></a> [dd\_alerts\_to](#input\_dd\_alerts\_to) | Where to send datadog alerts (disabled if empty) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | This will provide the created ALB ARN |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | This will provide the created ALB DNS Name |
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | This will provide the created ALB ID |
| <a name="output_http_tcp_listener_arns"></a> [http\_tcp\_listener\_arns](#output\_http\_tcp\_listener\_arns) | The ARN of the TCP and HTTP load balancer listeners created. |
| <a name="output_http_tcp_listener_ids"></a> [http\_tcp\_listener\_ids](#output\_http\_tcp\_listener\_ids) | The IDs of the TCP and HTTP load balancer listeners created. |
| <a name="output_https_listener_arns"></a> [https\_listener\_arns](#output\_https\_listener\_arns) | The ARNs of the HTTPS load balancer listeners created. |
| <a name="output_https_listener_ids"></a> [https\_listener\_ids](#output\_https\_listener\_ids) | The IDs of the load balancer listeners created. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
| <a name="output_target_group_attachments"></a> [target\_group\_attachments](#output\_target\_group\_attachments) | ARNs of the target group attachment IDs. |
| <a name="output_target_group_names"></a> [target\_group\_names](#output\_target\_group\_names) | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. |
<!-- END_TF_DOCS -->
