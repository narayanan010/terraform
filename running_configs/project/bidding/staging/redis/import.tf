import {
    to = aws_elasticache_replication_group.bidding_staging_redis
    id = "bidding-staging"
}

import {
    to = aws_elasticache_subnet_group.tf-subnetgroup-bidding-staging
    id = "tf-subnetgroup-bidding-staging"
}

import {
    to = aws_kms_alias.bidding-staging-kms
    id = "alias/bidding-staging"
}

import {
    to = aws_kms_key.bidding-staging-kms-key
    id = "fb078e93-bf93-4bc4-b7fe-f991f2fe4496"
}

import {
    to = aws_ssm_parameter.bidding-staging-ssm-redis-random-name
    id = "redis_random_name-bidding-staging"
}