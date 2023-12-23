See DEVOPS-11534 for details

# Rationale

For reasons unspecified, we wish to take data from scalyr and upload to a bucket not controlled
by the Capterra organization.

But wait, there's more!  Our only access to that bucket is by an assumed role in the foreign account.

So looking at our options:

## CopyObject

https://docs.aws.amazon.com/AmazonS3/latest/API/API_CopyObject.html

Requires that a singular identity have read from the source (capterra) bucket and write to the destination bucket.

We do not have confidence of control over the `dm-prod-cap-s3-crossaccount` role, and thus do not rely on this metho.

## CrossRegionReplication

https://aws.amazon.com/s3/features/replication/

Similar to the above, requires sufficient control over the writer role to successfully permit assumption by an AWS
controlled principal, which again, we're lacking.

## Manual-Esque copying

Which leads us to the only viable option that doesn't require us to manipulate the far-side role,
chaining S3 events to a lambda and doing the copy in lambda scope.

Yay.


