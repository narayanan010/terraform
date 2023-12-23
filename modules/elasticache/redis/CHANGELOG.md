## [v1.1.1](https://github.com/capterra/terraform/tree/module_redis-v1.1.1/modules/elasticache/redis)

NEW FEATURES:

* Removed unnecesary provider entries & reported bug issue with tags on `resource "aws_kms_key"``
    [[Bug]: aws_kms_key: tag propagation: timeout while waiting for state to become 'TRUE' (last state: 'FALSE', timeout: 5m0s) #27422](https://github.com/hashicorp/terraform-provider-aws/issues/27422)

* Enabled prefix-lists for inbound rules in security group. New variable `allowed_prefix_list`

* Updated default Redis version to `7.0`
    
## [v1.1.0](https://github.com/capterra/terraform/tree/module_redis-v1.1.0/modules/elasticache/redis)

INITIAL DEPLOYMENT
