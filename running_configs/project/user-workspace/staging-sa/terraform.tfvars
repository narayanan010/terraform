user_workspace_custom_domain_name_ga = "wauth-staging-ga.capstage.net"
user_workspace_custom_domain_name_sa = "wauth-staging-sa.capstage.net"

post_confirmation_lambda_arn   = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPostConfirmation"
post_authentication_lambda_arn = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPostAuthentication"
pre_signup_lambda_arn          = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPreSignup"

certificate_arn_ga = "arn:aws:acm:us-east-1:273213456764:certificate/efad5296-602f-43ca-bafc-ecb71aa5f34b"
certificate_arn_sa = "arn:aws:acm:us-east-1:273213456764:certificate/9622790d-2e00-46ac-b585-71b9da0990a7"
uw_ses_arn         = "arn:aws:ses:us-east-1:273213456764:identity/software@capterra.com"
uw_callback_urls   = ["https://www.capstage.net/workspace/oauth2/idpresponse"]
uw_signout_urls    = ["https://www.capstage.net/workspace/", "https://www.capstage.net"]

google_client_id        = "756105029491-67ll831sc6uthqm9sfpkfmceqno5397k.apps.googleusercontent.com"
google_client_secret    = "MFmBQy2yeBG0OaG3gitLn-3m"
google_client_id_ga     = "756105029491-slgupf8esbp438a49kt8bga9smhbl270.apps.googleusercontent.com"
google_client_secret_ga = "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"
google_client_id_sa     = "756105029491-d7la9opb64dueuh22svumed1okgbqrno.apps.googleusercontent.com"
google_client_secret_sa = "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"

stage       = "staging"
environment = "STAGING"
pool_type   = "oauth"
