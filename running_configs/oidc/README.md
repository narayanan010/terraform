# OIDC Provider


IAM OIDC identity providers are entities in IAM that describe an external identity provider (IdP) service that supports the OpenID Connect (OIDC) standard. 

This IAM OIDC identity provider is used to trust GitHub as a federated identity provider, and then use ID tokens in Github Actions workflows to authenticate to AWS and access resources. IAM roles attached is used to allow workflows to assume those roles in a granular way.


GitHub Docs for OpenID

* [Configuring OpenID Connect in cloud providers](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers)

&nbsp;

## Domain of the OIDC Provider

OIDC Provider is configured with Terraform locals to use with:

  - GitHub organization = local.GitHubOrg
  - GitHub repositories = local.GitHubRepo
  - AWS Assume Roles = local.Capterra_AssumeRole
  - AWS DynamoDB Table = local.DynamodbTable
  - AWS DynamoDB Table = local.DynamodbTable


Outsides of defined whitelist, OIDC won't work. To add additional repositories or assume roles, following locals should be updated: 

  - GitHub repositories = local.GitHubRepo
  - AWS Assume Roles = local.Capterra_AssumeRole

Example of last status of [IAM.tf](./capterra-aws-admin/iam.tf#L1-L18)

```
locals {
  GitHubOrg = "capterra"
  GitHubRepo = ["capterra-eks","terraform"]
  Capterra_AssumeRole = [
    "arn:aws:iam::176540105868:role/assume-capterra-admin",
    "arn:aws:iam::377773991577:role/capterra-admin-role",
    "arn:aws:iam::350125959894:role/gdm-admin-access",
    "arn:aws:iam::738909422062:role/assume-crf-production-admin",
    "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin",
    "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin",
    "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin",
    "arn:aws:iam::314485990717:role/assume-capterra-orange-staging-admin-nonmfa",
    "arn:aws:iam::888548925459:role/assume-capterra-wordpress-sbox-admin",
    "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin",
  ]
  DynamodbTable = "capterra-terraform-lock-table"
  TerraformStateBucket = "capterra-terraform-state"
}
```

&nbsp;

## Onboarding new accounts

If new account is added or need to modify roles assumed or actions, then the IAM policy need to be updated.

The scope of roles that can be assumed are defined over the policy:

- [STS AssumeRole](./capterra-aws-admin/iam.tf#L4-L15)

If some roles should be remplaced......

&nbsp;

The scope of actions allowed are defined over the policy:

- [IAM Policy](./capterra-aws-admin/iam.tf#L47-L106)

If more actions are required, the policy should be updated.

