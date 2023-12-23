resource "aws_iam_openid_connect_provider" "githuboidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = local.thumbprints
}

data "tls_certificate" "github_actions_oidc_endpoint" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  # GitHub's root cert: DigiCert TLS RSA SHA256 2020 CA1
  root_cert_thumbprint = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  # Whenever GitHub updates its cert list, we'll have to re-apply the TF module
  thumbprints = concat(data.tls_certificate.github_actions_oidc_endpoint.certificates[*].sha1_fingerprint, [local.root_cert_thumbprint])
}
