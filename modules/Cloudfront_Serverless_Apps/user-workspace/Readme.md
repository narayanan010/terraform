# Cloudfront module for Serverless-Apps for Capterra.
    This module is for creating CF distro for User Workspace application in Capterra.
    
# This module should:
# Create Amazon certificate (ACM).
# Will wait for ACM certificate to wait for to get to issued Status
## Create Cloudfront Distribution with:-
### Error page redirecting 404 and 403 errors to index.html
### Origin access identity
### Default Cache Behavior and One ordered Cache Behavior
### Also creates one origin for S3
## Create DNS record in appropriate Hosted zone to point to the cloudfront distribution.

# NOTE: This module does not create S3 bucket. Existing S3 bucket name can be given as an input under the variable "bucketName".