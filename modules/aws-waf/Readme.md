<!-- BEGIN_TF_DOCS -->
# Module for WAF.
This module is for creating an AWS WAF (V2).
This module is meant to be used by all the WAF that needs it. it could be easily adapted/extended with new rules or rules' set without affecting the existing resources.
    
## What this module will do?
* Create an AWS WAF (aws_wafv2_web_acl)
* Create the rules in the WAF according with the variables used
* Create specific IP sets (allowlist, denylist, nginx_server) if the correspondent rules are activated
* If the logging is enabled, and no logging destination is specified, it will create a Cloudwatch log group
* If the logging is enabled, it will create the logging configuration of the WAF according with the variables used

## Usage:

When making use of this module:
  1. Define a variable for the role to be assumed and for the region in which you need to work:
    ```
    variable "modulecaller_source_region" {
      default     = "us-east-1"
      description = "Region to be passed to Provider info where calling module"
    }

    variable "modulecaller_assume_role_deployer_account" {
      default     = "arn:aws:iam::350125959894:role/assume-capterra-crf-stg-admin-mfa"
      description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
    }

    ```
  2. Reference those variables in your provider.tf:
    ```
    data "aws_caller_identity" "current" {}

    terraform {
      backend "s3" {}
      required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.13.0"
            configuration_aliases = [ aws.primary ]
          }
      }
    }

    provider "aws" {
      alias   = "primary"
      region  = var.modulecaller_source_region
      assume_role {
        role_arn = var.modulecaller_assume_role_deployer_account
      }
    }
    ```
  3. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  4. Replace value of all the variables of the module per need


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags_resource_module"></a> [tags\_resource\_module](#module\_tags\_resource\_module) | git::https://github.com/capterra/terraform.git//modules/tagging-resource-module | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.waf-log-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_ip_set.allow_ip_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.deny_ip_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_ip_set.nginx_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.waf-acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.waf-acl-logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_managed_rules_admin_protection_set_AdminProtection_URIPATH_excluded"></a> [aws\_managed\_rules\_admin\_protection\_set\_AdminProtection\_URIPATH\_excluded](#input\_aws\_managed\_rules\_admin\_protection\_set\_AdminProtection\_URIPATH\_excluded) | Define if AdminProtection\_URIPATH rule should be excluded (set to count) from the AWS Managed Admin Protection Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_admin_protection_set_enabled"></a> [aws\_managed\_rules\_admin\_protection\_set\_enabled](#input\_aws\_managed\_rules\_admin\_protection\_set\_enabled) | Define if AWSManagedRulesAdminProtectionRuleSet rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_admin_protection_set_priority"></a> [aws\_managed\_rules\_admin\_protection\_set\_priority](#input\_aws\_managed\_rules\_admin\_protection\_set\_priority) | Define the priority for AWSManagedRulesAdminProtectionRuleSet rule. This is AWS managed rule. | `number` | `110` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryAdvertising_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryAdvertising\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryAdvertising\_excluded) | Define if CategoryAdvertising rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryArchiver_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryArchiver\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryArchiver\_excluded) | Define if CategoryArchiver rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryContentFetcher_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryContentFetcher\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryContentFetcher\_excluded) | Define if CategoryContentFetcher rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryEmailClient_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryEmailClient\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryEmailClient\_excluded) | Define if CategoryEmailClient rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryHttpLibrary_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryHttpLibrary\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryHttpLibrary\_excluded) | Define if CategoryHttpLibrary rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryLinkChecker_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryLinkChecker\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryLinkChecker\_excluded) | Define if CategoryLinkChecker rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryMiscellaneous_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryMiscellaneous\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryMiscellaneous\_excluded) | Define if CategoryMiscellaneous rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryMonitoring_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryMonitoring\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryMonitoring\_excluded) | Define if CategoryMonitoring rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategoryScrapingFramework_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryScrapingFramework\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategoryScrapingFramework\_excluded) | Define if CategoryScrapingFramework rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategorySearchEngine_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySearchEngine\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySearchEngine\_excluded) | Define if CategorySearchEngine rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategorySecurity_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySecurity\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySecurity\_excluded) | Define if CategorySecurity rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategorySeo_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySeo\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySeo\_excluded) | Define if CategorySeo rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_CategorySocialMedia_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySocialMedia\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_CategorySocialMedia\_excluded) | Define if CategorySocialMedia rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_SignalAutomatedBrowser_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_SignalAutomatedBrowser\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_SignalAutomatedBrowser\_excluded) | Define if SignalAutomatedBrowser rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_SignalKnownBotDataCenter_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_SignalKnownBotDataCenter\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_SignalKnownBotDataCenter\_excluded) | Define if SignalKnownBotDataCenter rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_SignalNonBrowserUserAgent_excluded"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_SignalNonBrowserUserAgent\_excluded](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_SignalNonBrowserUserAgent\_excluded) | Define if SignalNonBrowserUserAgent rule should be excluded (set to count) from the AWS Managed Bot Control rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_enabled"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_enabled](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_enabled) | Define if AWSManagedRulesBotControlRuleSet rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_bot_control_rule_set_priority"></a> [aws\_managed\_rules\_bot\_control\_rule\_set\_priority](#input\_aws\_managed\_rules\_bot\_control\_rule\_set\_priority) | Define the priority for AWSManagedRulesBotControlRuleSet rule. This is AWS managed rule. | `number` | `150` | no |
| <a name="input_aws_managed_rules_common_rule_set_CrossSiteScripting_BODY_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_BODY\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_BODY\_excluded) | Define if CrossSiteScripting\_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_CrossSiteScripting_COOKIE_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_COOKIE\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_COOKIE\_excluded) | Define if CrossSiteScripting\_COOKIE rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_CrossSiteScripting_QUERYARGUMENTS_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_QUERYARGUMENTS\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_QUERYARGUMENTS\_excluded) | Define if CrossSiteScripting\_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_CrossSiteScripting_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_CrossSiteScripting\_URIPATH\_excluded) | Define if CrossSiteScripting\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_EC2MetaDataSSRF_BODY_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_BODY\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_BODY\_excluded) | Define if EC2MetaDataSSRF\_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_EC2MetaDataSSRF_COOKIE_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_COOKIE\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_COOKIE\_excluded) | Define if EC2MetaDataSSRF\_COOKIE rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_EC2MetaDataSSRF_QUERYARGUMENTS_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_QUERYARGUMENTS\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_QUERYARGUMENTS\_excluded) | Define if EC2MetaDataSSRF\_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_EC2MetaDataSSRF_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_EC2MetaDataSSRF\_URIPATH\_excluded) | Define if EC2MetaDataSSRF\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericLFI_BODY_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_BODY\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_BODY\_excluded) | Define if GenericLFI\_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericLFI_QUERYARGUMENTS_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_QUERYARGUMENTS\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_QUERYARGUMENTS\_excluded) | Define if GenericLFI\_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericLFI_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericLFI\_URIPATH\_excluded) | Define if GenericLFI\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericRFI_BODY_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_BODY\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_BODY\_excluded) | Define if GenericRFI\_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericRFI_QUERYARGUMENTS_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_QUERYARGUMENTS\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_QUERYARGUMENTS\_excluded) | Define if GenericRFI\_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_GenericRFI_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_GenericRFI\_URIPATH\_excluded) | Define if GenericRFI\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_NoUserAgent_HEADER_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_NoUserAgent\_HEADER\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_NoUserAgent\_HEADER\_excluded) | Define if NoUserAgent\_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_RestrictedExtensions_QUERYARGUMENTS_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_RestrictedExtensions\_QUERYARGUMENTS\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_RestrictedExtensions\_QUERYARGUMENTS\_excluded) | Define if RestrictedExtensions\_QUERYARGUMENTS rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_RestrictedExtensions_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_RestrictedExtensions\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_RestrictedExtensions\_URIPATH\_excluded) | Define if RestrictedExtensions\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_SizeRestrictions_BODY_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_BODY\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_BODY\_excluded) | Define if SizeRestrictions\_BODY rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_SizeRestrictions_Cookie_HEADER_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_Cookie\_HEADER\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_Cookie\_HEADER\_excluded) | Define if SizeRestrictions\_Cookie\_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_SizeRestrictions_QUERYSTRING_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_QUERYSTRING\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_QUERYSTRING\_excluded) | Define if SizeRestrictions\_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_SizeRestrictions_URIPATH_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_URIPATH\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_SizeRestrictions\_URIPATH\_excluded) | Define if SizeRestrictions\_URIPATH rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_UserAgent_BadBots_HEADER_excluded"></a> [aws\_managed\_rules\_common\_rule\_set\_UserAgent\_BadBots\_HEADER\_excluded](#input\_aws\_managed\_rules\_common\_rule\_set\_UserAgent\_BadBots\_HEADER\_excluded) | Define if UserAgent\_BadBots\_HEADER rule should be excluded (set to count) from the AWS Managed Common Rule Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_enabled"></a> [aws\_managed\_rules\_common\_rule\_set\_enabled](#input\_aws\_managed\_rules\_common\_rule\_set\_enabled) | Define if AWSManagedRulesCommonRuleSet rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_common_rule_set_priority"></a> [aws\_managed\_rules\_common\_rule\_set\_priority](#input\_aws\_managed\_rules\_common\_rule\_set\_priority) | Define the priority for AWSManagedRulesCommonRuleSet rule set. | `number` | `90` | no |
| <a name="input_aws_managed_rules_ip_anonymous_list_AnonymousIPList_excluded"></a> [aws\_managed\_rules\_ip\_anonymous\_list\_AnonymousIPList\_excluded](#input\_aws\_managed\_rules\_ip\_anonymous\_list\_AnonymousIPList\_excluded) | Define if AnonymousIPList rule should be excluded (set to count) from the AWS Managed IP Anonymous list. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_anonymous_list_HostingProviderIPList_excluded"></a> [aws\_managed\_rules\_ip\_anonymous\_list\_HostingProviderIPList\_excluded](#input\_aws\_managed\_rules\_ip\_anonymous\_list\_HostingProviderIPList\_excluded) | Define if HostingProviderIPList rule should be excluded (set to count) from the AWS Managed IP Anonymous list. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_anonymous_list_enabled"></a> [aws\_managed\_rules\_ip\_anonymous\_list\_enabled](#input\_aws\_managed\_rules\_ip\_anonymous\_list\_enabled) | Define if AWSManagedRulesAnonymousIpList rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_anonymous_list_priority"></a> [aws\_managed\_rules\_ip\_anonymous\_list\_priority](#input\_aws\_managed\_rules\_ip\_anonymous\_list\_priority) | Define the priority for AWSManagedRulesAnonymousIpList rule. This is AWS managed rule. | `number` | `130` | no |
| <a name="input_aws_managed_rules_ip_reputation_list_AWSManagedIPReputationList_excluded"></a> [aws\_managed\_rules\_ip\_reputation\_list\_AWSManagedIPReputationList\_excluded](#input\_aws\_managed\_rules\_ip\_reputation\_list\_AWSManagedIPReputationList\_excluded) | Define if AWSManagedIPReputationList rule should be excluded (set to count) from the AWS Managed IP Reputation list. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_reputation_list_AWSManagedReconnaissanceList_excluded"></a> [aws\_managed\_rules\_ip\_reputation\_list\_AWSManagedReconnaissanceList\_excluded](#input\_aws\_managed\_rules\_ip\_reputation\_list\_AWSManagedReconnaissanceList\_excluded) | Define if AWSManagedReconnaissanceList rule should be excluded (set to count) from the AWS Managed IP Reputation list. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_reputation_list_enabled"></a> [aws\_managed\_rules\_ip\_reputation\_list\_enabled](#input\_aws\_managed\_rules\_ip\_reputation\_list\_enabled) | Define if AWSManagedRulesAmazonIpReputationList rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_ip_reputation_list_priority"></a> [aws\_managed\_rules\_ip\_reputation\_list\_priority](#input\_aws\_managed\_rules\_ip\_reputation\_list\_priority) | Define the priority for AWSManagedRulesAmazonIpReputationList rule. This is AWS managed rule. | `number` | `120` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_ExploitablePaths_URIPATH_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_ExploitablePaths\_URIPATH\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_ExploitablePaths\_URIPATH\_excluded) | Define if ExploitablePaths\_URIPATH rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_Host_localhost_HEADER_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_Host\_localhost\_HEADER\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_Host\_localhost\_HEADER\_excluded) | Define if Host\_localhost\_HEADER rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_BODY_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_BODY\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_BODY\_excluded) | Define if JavaDeserializationRCE\_BODY rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_HEADER_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_HEADER\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_HEADER\_excluded) | Define if JavaDeserializationRCE\_HEADER rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_QUERYSTRING_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_QUERYSTRING\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_QUERYSTRING\_excluded) | Define if JavaDeserializationRCE\_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_JavaDeserializationRCE_URIPATH_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_URIPATH\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_JavaDeserializationRCE\_URIPATH\_excluded) | Define if JavaDeserializationRCE\_URIPATH rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_Log4JRCE_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_Log4JRCE\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_Log4JRCE\_excluded) | Define if Log4JRCE rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_ad_inputs_set_PROPFIND_METHOD_excluded"></a> [aws\_managed\_rules\_known\_ad\_inputs\_set\_PROPFIND\_METHOD\_excluded](#input\_aws\_managed\_rules\_known\_ad\_inputs\_set\_PROPFIND\_METHOD\_excluded) | Define if PROPFIND\_METHOD rule should be excluded (set to count) from the AWS Managed Known Bad Inputs Set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_bad_inputs_set_enabled"></a> [aws\_managed\_rules\_known\_bad\_inputs\_set\_enabled](#input\_aws\_managed\_rules\_known\_bad\_inputs\_set\_enabled) | Define if AWSManagedRulesKnownBadInputsRuleSet rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_known_bad_inputs_set_priority"></a> [aws\_managed\_rules\_known\_bad\_inputs\_set\_priority](#input\_aws\_managed\_rules\_known\_bad\_inputs\_set\_priority) | Define the priority for AWSManagedRulesKnownBadInputsRuleSet rule. This is AWS managed rule. | `number` | `100` | no |
| <a name="input_aws_managed_rules_linux_rule_set_LFI_COOKIE_excluded"></a> [aws\_managed\_rules\_linux\_rule\_set\_LFI\_COOKIE\_excluded](#input\_aws\_managed\_rules\_linux\_rule\_set\_LFI\_COOKIE\_excluded) | Define if LFI\_COOKIE rule should be excluded (set to count) from the AWS Managed Linux rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_linux_rule_set_enabled"></a> [aws\_managed\_rules\_linux\_rule\_set\_enabled](#input\_aws\_managed\_rules\_linux\_rule\_set\_enabled) | Define if AWSManagedRulesLinuxRuleSet rule is enabled. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_linux_rule_set_priority"></a> [aws\_managed\_rules\_linux\_rule\_set\_priority](#input\_aws\_managed\_rules\_linux\_rule\_set\_priority) | Define the priority for AWSManagedRulesLinuxRuleSet rule. This is AWS managed rule. | `number` | `140` | no |
| <a name="input_aws_managed_rules_linux_rule_sett_LFI_QUERYSTRING_excluded"></a> [aws\_managed\_rules\_linux\_rule\_sett\_LFI\_QUERYSTRING\_excluded](#input\_aws\_managed\_rules\_linux\_rule\_sett\_LFI\_QUERYSTRING\_excluded) | Define if LFI\_QUERYSTRING rule should be excluded (set to count) from the AWS Managed Linux rule set. | `bool` | `false` | no |
| <a name="input_aws_managed_rules_linux_rule_sett_LFI_URIPATH_excluded"></a> [aws\_managed\_rules\_linux\_rule\_sett\_LFI\_URIPATH\_excluded](#input\_aws\_managed\_rules\_linux\_rule\_sett\_LFI\_URIPATH\_excluded) | Define if LFI\_URIPATH rule should be excluded (set to count) from the AWS Managed Linux rule set. | `bool` | `false` | no |
| <a name="input_cloudfront_empty_user_agent_rule_priority"></a> [cloudfront\_empty\_user\_agent\_rule\_priority](#input\_cloudfront\_empty\_user\_agent\_rule\_priority) | Define the priority for cloudfront-empty-user-agent rule. | `number` | `20` | no |
| <a name="input_cloudfront_empty_user_agent_rule_status"></a> [cloudfront\_empty\_user\_agent\_rule\_status](#input\_cloudfront\_empty\_user\_agent\_rule\_status) | Define if the rule cloudfront-empty-user-agent is enabled and the working mode. The valid values are: disabled, count, block, allow. | `string` | `"disabled"` | no |
| <a name="input_custom_allow_ip_list_address_version"></a> [custom\_allow\_ip\_list\_address\_version](#input\_custom\_allow\_ip\_list\_address\_version) | Version of the IP Address version, ex. IPV4 or IPV6 | `string` | `"IPV4"` | no |
| <a name="input_custom_allow_ip_list_addresses"></a> [custom\_allow\_ip\_list\_addresses](#input\_custom\_allow\_ip\_list\_addresses) | Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list | `list(string)` | `[]` | no |
| <a name="input_custom_allow_ip_list_rule_priority"></a> [custom\_allow\_ip\_list\_rule\_priority](#input\_custom\_allow\_ip\_list\_rule\_priority) | Define the priority for allow-ip-list rule. | `number` | `10` | no |
| <a name="input_custom_allow_ip_list_status"></a> [custom\_allow\_ip\_list\_status](#input\_custom\_allow\_ip\_list\_status) | Define if the rule allow-ip-list is enabled and the working mode. The valid values are: disabled, count, allow. | `string` | `"disabled"` | no |
| <a name="input_custom_deny_ip_list_address_version"></a> [custom\_deny\_ip\_list\_address\_version](#input\_custom\_deny\_ip\_list\_address\_version) | Version of the IP Address version, ex. IPV4 or IPV6 | `string` | `"IPV4"` | no |
| <a name="input_custom_deny_ip_list_addresses"></a> [custom\_deny\_ip\_list\_addresses](#input\_custom\_deny\_ip\_list\_addresses) | Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list | `list(string)` | `[]` | no |
| <a name="input_custom_deny_ip_list_rule_priority"></a> [custom\_deny\_ip\_list\_rule\_priority](#input\_custom\_deny\_ip\_list\_rule\_priority) | Define the priority for deny-ip-list rule. | `number` | `10` | no |
| <a name="input_custom_deny_ip_list_status"></a> [custom\_deny\_ip\_list\_status](#input\_custom\_deny\_ip\_list\_status) | Define if the rule deny-ip-list is enabled and the working mode. The valid values are: disabled, count, block. | `string` | `"disabled"` | no |
| <a name="input_custom_path_checker_action_list"></a> [custom\_path\_checker\_action\_list](#input\_custom\_path\_checker\_action\_list) | The variable is a list of object that must have uri\_path, uri\_path\_constraint, action, priority. Adding an object will result in a rule creation in which for a specific path the rule allows, block or count. Value of uri\_path\_constraint must be one of: EXACTLY, STARTS\_WITH, ENDS\_WITH, CONTAINS, CONTAINS\_WORD; Value of size\_comparison\_operator must be one of: EQ, NE, LE, LT, GE, or GT. Value of action must be one of: count, block, allow. The path provided must start with / . | <pre>list(object({<br>    uri_path                          = string<br>    uri_path_constraint               = string<br>    action                            = string<br>    priority                          = number<br>  }))</pre> | `[]` | no |
| <a name="input_custom_path_checker_action_list_rule_priority"></a> [custom\_path\_checker\_action\_list\_rule\_priority](#input\_custom\_path\_checker\_action\_list\_rule\_priority) | Define the priority for path-size-action rule. | `number` | `40` | no |
| <a name="input_custom_path_size_checker_action_list"></a> [custom\_path\_size\_checker\_action\_list](#input\_custom\_path\_size\_checker\_action\_list) | The variable is a list of object that must have uri\_path, uri\_path\_constraint, size, size\_comparison\_operator, action, priority. Adding an object will result in a rule creation in which for a specific path and size the rule allows, block or count. Value of uri\_path\_constraint must be one of: EXACTLY, STARTS\_WITH, ENDS\_WITH, CONTAINS, CONTAINS\_WORD; Value of size\_comparison\_operator must be one of: EQ, NE, LE, LT, GE, or GT. Value of action must be one of: count, block, allow. The path provided must start with / . | <pre>list(object({<br>    uri_path                          = string<br>    uri_path_constraint               = string<br>    size                              = number<br>    size_comparison_operator          = string<br>    action                            = string<br>    priority                          = number<br>  }))</pre> | `[]` | no |
| <a name="input_custom_path_size_checker_action_list_rule_priority"></a> [custom\_path\_size\_checker\_action\_list\_rule\_priority](#input\_custom\_path\_size\_checker\_action\_list\_rule\_priority) | Define the priority for path-size-action rule. | `number` | `10` | no |
| <a name="input_nginx_server_list_rule_priority"></a> [nginx\_server\_list\_rule\_priority](#input\_nginx\_server\_list\_rule\_priority) | Define the priority for nginx-server-list rule. | `number` | `10` | no |
| <a name="input_nginx_server_list_rule_status"></a> [nginx\_server\_list\_rule\_status](#input\_nginx\_server\_list\_rule\_status) | Define if the rule nginx-server-list is enabled and the working mode. The valid values are: disabled, count, block, allow. | `string` | `"disabled"` | no |
| <a name="input_nginx_servers_ip_list_address_version"></a> [nginx\_servers\_ip\_list\_address\_version](#input\_nginx\_servers\_ip\_list\_address\_version) | Version of the IP Address version, ex. IPV4 or IPV6 | `string` | `"IPV4"` | no |
| <a name="input_nginx_servers_ip_list_addresses"></a> [nginx\_servers\_ip\_list\_addresses](#input\_nginx\_servers\_ip\_list\_addresses) | Array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. It is a list | `list(string)` | `[]` | no |
| <a name="input_oversized_requests_rule_priority"></a> [oversized\_requests\_rule\_priority](#input\_oversized\_requests\_rule\_priority) | Define the priority for oversized requests rule. | `number` | `15` | no |
| <a name="input_oversized_requests_rule_status"></a> [oversized\_requests\_rule\_status](#input\_oversized\_requests\_rule\_status) | Define if oversized requests should be checked. The valid values are: disabled, count, block, allow. | `string` | `"disabled"` | no |
| <a name="input_rate_limit_rule_aggregate_key_type"></a> [rate\_limit\_rule\_aggregate\_key\_type](#input\_rate\_limit\_rule\_aggregate\_key\_type) | Define the value for aggregate\_key\_type for rule rate-limit | `string` | `"IP"` | no |
| <a name="input_rate_limit_rule_forwarded_ip_fallback_behaviour"></a> [rate\_limit\_rule\_forwarded\_ip\_fallback\_behaviour](#input\_rate\_limit\_rule\_forwarded\_ip\_fallback\_behaviour) | Define the value fallback behaviour for rule rate-limit. Used only if aggregate\_key\_type is FORWARDED\_IP. | `string` | `"MATCH"` | no |
| <a name="input_rate_limit_rule_forwarded_ip_header_name"></a> [rate\_limit\_rule\_forwarded\_ip\_header\_name](#input\_rate\_limit\_rule\_forwarded\_ip\_header\_name) | Define the name of the header for rule rate-limit. Used only if aggregate\_key\_type is FORWARDED\_IP. | `string` | `"X-Real-IP"` | no |
| <a name="input_rate_limit_rule_priority"></a> [rate\_limit\_rule\_priority](#input\_rate\_limit\_rule\_priority) | Define the priority for rate-limit rule. | `number` | `20` | no |
| <a name="input_rate_limit_rule_status"></a> [rate\_limit\_rule\_status](#input\_rate\_limit\_rule\_status) | Define if the rule rate-limit is enabled and the working mode. The valid values are: disabled, count, block, allow. | `string` | `"disabled"` | no |
| <a name="input_rate_limit_rule_value"></a> [rate\_limit\_rule\_value](#input\_rate\_limit\_rule\_value) | Define the limit value for rule rate-limit | `number` | `100` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage this resource belongs to (dev/prod/staging/sandbox) | `string` | `"sandbox"` | no |
| <a name="input_tag_app_component"></a> [tag\_app\_component](#input\_tag\_app\_component) | n/a | `string` | `""` | no |
| <a name="input_tag_app_contacts"></a> [tag\_app\_contacts](#input\_tag\_app\_contacts) | n/a | `string` | `"opsteam@capterra.com"` | no |
| <a name="input_tag_app_environment"></a> [tag\_app\_environment](#input\_tag\_app\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_application"></a> [tag\_application](#input\_tag\_application) | tags. These values can be overwritten when calling module. | `string` | `""` | no |
| <a name="input_tag_business_unit"></a> [tag\_business\_unit](#input\_tag\_business\_unit) | n/a | `string` | `""` | no |
| <a name="input_tag_created_by"></a> [tag\_created\_by](#input\_tag\_created\_by) | n/a | `string` | `"fabio.perrone@gartner.com"` | no |
| <a name="input_tag_environment"></a> [tag\_environment](#input\_tag\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_function"></a> [tag\_function](#input\_tag\_function) | n/a | `string` | `""` | no |
| <a name="input_tag_monitoring"></a> [tag\_monitoring](#input\_tag\_monitoring) | n/a | `string` | `""` | no |
| <a name="input_tag_network_environment"></a> [tag\_network\_environment](#input\_tag\_network\_environment) | n/a | `string` | `""` | no |
| <a name="input_tag_product"></a> [tag\_product](#input\_tag\_product) | n/a | `string` | `""` | no |
| <a name="input_tag_region"></a> [tag\_region](#input\_tag\_region) | n/a | `string` | `""` | no |
| <a name="input_tag_system_risk_class"></a> [tag\_system\_risk\_class](#input\_tag\_system\_risk\_class) | n/a | `string` | `"3"` | no |
| <a name="input_tag_terraform_managed"></a> [tag\_terraform\_managed](#input\_tag\_terraform\_managed) | n/a | `string` | `"true"` | no |
| <a name="input_tag_vertical"></a> [tag\_vertical](#input\_tag\_vertical) | n/a | `string` | `""` | no |
| <a name="input_vertical"></a> [vertical](#input\_vertical) | Vertical this resource belongs to (capterra/getapp/softwareadvice) | `string` | `"capterra"` | no |
| <a name="input_waf_logging_destination"></a> [waf\_logging\_destination](#input\_waf\_logging\_destination) | Define the destination of the logs. If not specified, but waf\_logging\_enabled is true, then a new Cloudwatch log group is created | `string` | `""` | no |
| <a name="input_waf_logging_enabled"></a> [waf\_logging\_enabled](#input\_waf\_logging\_enabled) | Define if the logging has to be enabled or not for the WAF | `bool` | `false` | no |
| <a name="input_waf_logging_filter_default_behavior"></a> [waf\_logging\_filter\_default\_behavior](#input\_waf\_logging\_filter\_default\_behavior) | Define the default behavior of the log filter | `string` | `"KEEP"` | no |
| <a name="input_waf_logging_filter_enabled"></a> [waf\_logging\_filter\_enabled](#input\_waf\_logging\_filter\_enabled) | Define if WAF logs filter is enabled | `bool` | `false` | no |
| <a name="input_waf_logging_filters"></a> [waf\_logging\_filters](#input\_waf\_logging\_filters) | Define the logging filter behaviour and the conditions required in each filter. | <pre>list(object({<br>    behavior                          = string<br>    requirement                       = string<br>    conditions                        = list(object({<br>      type                              = string<br>      effect                            = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_waf_logging_kms_key"></a> [waf\_logging\_kms\_key](#input\_waf\_logging\_kms\_key) | Define the key to be used for logs encryption (the Key will need the right permissions first). If not specified the logs will not be encrypted | `string` | `""` | no |
| <a name="input_waf_logging_redacted_field_method"></a> [waf\_logging\_redacted\_field\_method](#input\_waf\_logging\_redacted\_field\_method) | Define if it is needed to redact the method in the logs | `bool` | `false` | no |
| <a name="input_waf_logging_redacted_field_query_string"></a> [waf\_logging\_redacted\_field\_query\_string](#input\_waf\_logging\_redacted\_field\_query\_string) | Define if it is needed to redact the query string in the logs | `bool` | `false` | no |
| <a name="input_waf_logging_redacted_field_single_header"></a> [waf\_logging\_redacted\_field\_single\_header](#input\_waf\_logging\_redacted\_field\_single\_header) | Define if it is needed to redact a single header in the logs | `bool` | `false` | no |
| <a name="input_waf_logging_redacted_field_single_header_name"></a> [waf\_logging\_redacted\_field\_single\_header\_name](#input\_waf\_logging\_redacted\_field\_single\_header\_name) | Define the name of the single header to be redacted in the logs | `string` | `"user-agent"` | no |
| <a name="input_waf_logging_redacted_field_uri_path"></a> [waf\_logging\_redacted\_field\_uri\_path](#input\_waf\_logging\_redacted\_field\_uri\_path) | Define if it is needed to redact the request URI path in the logs | `bool` | `false` | no |
| <a name="input_waf_logging_retention"></a> [waf\_logging\_retention](#input\_waf\_logging\_retention) | Define the logs retention in days | `number` | `0` | no |
| <a name="input_web_acl_name"></a> [web\_acl\_name](#input\_web\_acl\_name) | Name of the Web ACL which needs to be created. | `string` | n/a | yes |
| <a name="input_web_acl_scope"></a> [web\_acl\_scope](#input\_web\_acl\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider. | `string` | `"CLOUDFRONT"` | no |
| <a name="waf_dd_alerts_to"></a> [waf\_dd\_alerts\_to](#waf\_dd\_alerts\_to) | Specifies the recipient of datadog alerts related to WAF anomalies, should be specified in datadog format (e.g., '@roomname-slack' or '@person@gartner.com') | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | This will provide the created Web ACL ARN |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | This will provide the created Web ACL capacity |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | This will provide the created Web ACL ID |

## Sections to be added to module caller's variables.tf, and output.tf below:

### Include Below section to provider.tf
```
data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.13.0"
        configuration_aliases = [ aws.primary ]
      }
  }
}

provider "aws" {
  alias   = "primary"
  region  = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}
```

### Include Below section to caller's variables.tf, Replace values of all the variables with name beginning with modulecaller_xxxx
```
variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  # default     = "arn:aws:iam::350125959894:role/assume-capterra-crf-stg-admin-mfa"
  default = "arn:aws:iam::350125959894:role/gdm-admin-access"
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}
```

## Examples:
### Example of main.tf
```
module "aws_waf_module" {
  source = "git@github.com:capterra/terraform.git//modules/aws-waf"
  # source = "../../../modules/aws-waf"

  #Web ACL                
  web_acl_name  = "module-trial"
  web_acl_scope = "CLOUDFRONT"
  vertical      = "capterra"
  stage         = "sandbox"

  # Rules to check specific paths and packet dimension (used in project CRF):
  custom_path_size_checker_action_list                                            = [
                                          {uri_path = "/review2", uri_path_constraint = "STARTS_WITH", size = 8192, size_comparison_operator = "GE", action = "allow", priority = 99},
                                          {uri_path = "/review/new", uri_path_constraint = "EXACTLY", size = 8192, size_comparison_operator = "GE", action = "allow", priority = 100}]

  # Rule to allow traffic from nginix server:
  nginx_servers_ip_list_address_version             = "IPV4"
  nginx_servers_ip_list_addresses                   = ["52.13.209.160/32", "34.205.192.229/32", "52.11.75.34/32", 
                                                      "35.143.224.66/32", "3.233.207.165/32", "35.172.62.29/32", 
                                                      "34.234.249.188/32","35.174.34.104/32", "34.207.38.254/32", 
                                                      "52.39.77.81/32"]
  nginx_server_list_rule_priority                                                 = 2
  nginx_server_list_rule_status                                                   = "allow"

  # Rule to check empty user agent, but set to count and not block:
  cloudfront_empty_user_agent_rule_priority                                       = 4
  cloudfront_empty_user_agent_rule_status                                         = "count"

  # Rule to block specific rate:
  rate_limit_rule_priority                                                     = 3
  rate_limit_rule_status                                                       = "block"
  rate_limit_rule_value                                                        = 100
  rate_limit_rule_aggregate_key_type                                           = "FORWARDED_IP"

  # Enable AWS Core rule set, but set the CrossSiteScripting_COOKIE rule as excluded
  aws_managed_rules_common_rule_set_enabled                                       = true
  aws_managed_rules_common_rule_set_CrossSiteScripting_COOKIE_excluded            = true
  aws_managed_rules_common_rule_set_priority                                      = 1

  # Deny specific IPs with a rule
  custom_deny_ip_list_status                                                      = "block"
  custom_deny_ip_list_rule_priority                                               = 0
  custom_deny_ip_list_address_version                                             = "IPV4"
  custom_deny_ip_list_addresses                                                   = ["194.163.144.246/32"]

  # Configure logging, creating a new log group, and filtering the logs
  waf_logging_enabled = true
  waf_logging_filter_enabled = true
  waf_logging_filter_default_behavior = "DROP"
  waf_logging_filters = [
    {behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{type = "action_condition", effect = "BLOCK"}]}
  ]

  providers = {
      aws.primary = aws.primary
  }

  # Specify tags here
  tag_application         = "test-new-waf-module"
  tag_app_component       = "waf"
  tag_function            = "security"
  tag_business_unit       = "gdm"
  tag_app_environment     = "sandbox"
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "fabio.perrone@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-east-1"
  tag_network_environment = "sandbox"
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "test-new-waf-module"
  tag_environment         = "sandbox"
}
```

### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output.
```  
output "web_acl_arn" {
  value       = module.aws_waf_module.web_acl_arn
  description = "This will provide the created Web ACL ARN"
}


output "web_acl_capacity" {
  value       = module.aws_waf_module.web_acl_capacity
  description = "This will provide the created Web ACL capacity"
}


output "web_acl_id" {
  value       = module.aws_waf_module.web_acl_id
  description = "This will provide the created Web ACL ID"
}
```

<!-- END_TF_DOCS -->
