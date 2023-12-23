include {
  path = find_in_parent_folders()
}

terraform {
  before_hook "lambda_zip_get_from_s3" {
    commands  = [ "apply", "plan" ]
    execute   = [ "/bin/bash", "-c", "./get_lambda_zips_from_s3.sh cloudfront_logs_push_to_newrelic" ]
  }
  before_hook "lambda_zip_refresh" {
    commands  = [ "apply", "plan" ]
    execute   = [ "/bin/bash", "-c", "./has_lambda_source_code_changed.sh cloudfront_logs_partitioning" ]
  }
}
