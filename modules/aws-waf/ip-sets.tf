#*************************************************************************************************************************************************************#
#                                                      			            IP SETS SECTION		                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_wafv2_ip_set" "deny_ip_list" {
  provider           = aws.primary
  count              = var.custom_deny_ip_list_status == "disabled" ? 0 : 1
  name               = "${var.vertical}-deny-${var.stage}-ip-set-${var.web_acl_name}"
  description        = "IP to be blocked"
  scope              = var.web_acl_scope
  ip_address_version = var.custom_deny_ip_list_address_version
  addresses          = var.custom_deny_ip_list_addresses
}

resource "aws_wafv2_ip_set" "allow_ip_list" {
  provider           = aws.primary
  count              = var.custom_allow_ip_list_status == "disabled" ? 0 : 1
  name               = "${var.vertical}-allow-${var.stage}-ip-set-${var.web_acl_name}"
  description        = "IP to be allowed"
  scope              = var.web_acl_scope
  ip_address_version = var.custom_allow_ip_list_address_version
  addresses          = var.custom_allow_ip_list_addresses
}

resource "aws_wafv2_ip_set" "allow_custom_ip_list" {
  provider           = aws.primary
  count              = var.custom_allow_app_ip_list_status == "disabled" ? 0 : 1
  name               = "${var.vertical}-allow-${var.stage}-${var.custom_app_name}-ip-set-${var.web_acl_name}"
  description        = "${var.custom_app_name} IPs to be allowed"
  scope              = var.web_acl_scope
  ip_address_version = var.custom_allow_app_ip_list_address_version
  addresses          = var.custom_allow_app_ip_list_addresses
}

resource "aws_wafv2_ip_set" "nginx_servers" {
  provider           = aws.primary
  count              = var.nginx_server_list_rule_status == "disabled" ? 0 : 1
  name               = "${var.vertical}-nginx-servers-${var.stage}-ip-set-${var.web_acl_name}"
  description        = "IP set of nginx servers"
  scope              = var.web_acl_scope
  ip_address_version = var.nginx_servers_ip_list_address_version
  addresses          = var.nginx_servers_ip_list_addresses
}
