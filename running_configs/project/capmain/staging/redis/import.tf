# import {
#     to = aws_elasticache_replication_group.capmain_staging_redis
#     id = "capmain-staging-redis"
# }

# import {
#     to = aws_elasticache_subnet_group.tf-subnetgroup-capmain-staging-redis
#     id = "tf-subnetgroup-capmain-staging-redis"
# }

# import {
#     to = aws_security_group.capmain_redis_sg
#     id = "sg-0a8c443cc6d3da30c"
# }

# import {
#     to = aws_kms_alias.capmain-staging-redis-kms-alias
#     id = "alias/capmain-staging-redis"
# }

# import {
#     to = aws_kms_key.capmain-staging-redis-kms-key
#     id = "a4b8d5bd-e03d-484c-900e-d93c63374ab4"
# }

import {
    to = aws_ssm_parameter.capmain-staging-ssm-redis-random-name
    id = "redis_random_name-capmain-staging-redis"
}