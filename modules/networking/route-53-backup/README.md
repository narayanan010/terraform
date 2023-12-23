
# Setup Route53 Backup 
Amazon Route53 is a managed DNS web service. Route53 is often a mission critical asset in the organization. 
 
The following tool enables:
 1. Create route53 backup bucket 
 2. Backup of Route53 DNS Records
 3. Backup of Route53 Health checks

## Architecture
![backup](https://github.com/capterra/terraform/blob/DEVOPS-11969/running_configs/route53backup/images/backup.png)

## Integrate backup module in terraform
This module can be integrated into an existing terraform framework. To add it, simply add the following module to your 
terraform code:
```
module "route53-backup" {
  source            = "route53backup/aws"
  aws_profile       = "dev"
  region            = "us-east-1"
  interval          = "120"
}
``` 
Please note that all the above values are the default values, and therefore these specific values can be omitted.

```
### Deployment parameters:

| Key             | Description                                             | Default value |
|-----------------|---------------------------------------------------------|---------------|
| profile         | AWS profile, from the AWS credentials file, to be used  | default       |
| region          | Region of resources to be deployed                      | us-east-1     |
| backup-interval | Interval, in minutes, of scheduled backup               | 120 minutes   |




## Route53 backup bucket security configuration
When the lambda creates the S3 bucket it ensures that it has:
* Bucket versioning enabled
* Data encrypted at rest
* Data encrypted at transport
* Bucket is set to private
* Bucket has lifecycle policy that deletes files older than `retention-period` days

