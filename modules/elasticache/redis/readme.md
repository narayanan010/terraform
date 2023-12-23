# Terraform module for Elasticache-Redis deployment in Capterra.
    Terraform Module will deploy Redis Module to Capterra AWS accounts. This will create EC Redis cluster based upon parameters provided. It can be single node or multi node cluster based upon value of variable `cluster_mode_enabled = true/false`
    
#### What this module will do?
```
  # This will create EC Redis cluster based upon parameters provided
  # This module will:
      * Create Elasticache Redis cluster based upon the parametes provided. It can be single node or multi node cluster based upon value of variable `cluster_mode_enabled = true/false`
      * It will set the `maintenance_window` for Redis. Default is `sat:03:30-sun:01:00`
      * `snapshot_window` will also be set and can be customised. Default is `01:30-03:20`
      * Default `snapshot_retention_limit` is set to 3 days. It can be customised.
      * Create KMS key, add alias to it if `at_rest_encryption_enabled = true is set`
      * Will enable transit encryption. To toggle option: use `transit_encryption_enabled = true/false`. If transit_encryption_enabled = true, a SSM parameter store of type `SecureString` is created with some random string generated that will be used as `auth_token`
      * Subnet Group will be created when `add_subnet_group = true`. To create new Subnet Group and add subnets to list use `subnet_list_to_add_to_subnet_group`. To use existing subnet_group define variable `elasticache_existing_subnet_group_name`. If no subnet group is passed, Default Subnet Group is added.
      * New Security Groups can be created, Ingress/Egress Rules can be defined. Existing SG can also be added as Source to newly created Security Group. Use variable `use_existing_security_groups = true/false` to toggle creation of SG. Other SG variables are: `existing_security_groups` , allowed_security_groups and `allowed_cidr_blocks`.
      * Module tag is being used for tagging each resource per Capterra/Gartner standard tags.
  # Note:
      * TF-AWS-provider doesn’t currently support MultiAZ) . Ref: 
        - https://github.com/terraform-providers/terraform-provider-aws/issues/13706 , 
        - https://github.com/terraform-providers/terraform-provider-aws/pull/13909
      * TF-AWS-provider currently doesn't support `Reader-Endpoint` too. Ref:
        - https://github.com/terraform-providers/terraform-provider-aws/issues/10519
      * When above features are supported, an enhancement would be required to this module to support Multi-AZ feature.
      * Related to this [[Bug]: aws_kms_key: tag propagation: timeout while waiting for state to become 'TRUE' (last state: 'FALSE', timeout: 5m0s) #27422](https://github.com/hashicorp/terraform-provider-aws/issues/27422)
      no tags should be passed to aws_kms_key (inside module)
```

### Usage:

When making use of this module:
  1. Replace the assume_role accordingly in variables in no. 2 below.
  2. The credentials used should have rights to assume roles passed to variables: 
        var.modulecaller_assume_role_primary_account
  3. Backend can be configured using terragrunt.hcl as done in Capterra.
  4. Read all 3 "Include Below section to" and include it to main.tf, variables.tf and output.tf of caller of module.
  5. Replace value of all the variables with name beginning with "modulecaller_" per need
  6. While calling module, include call to define providers {}. 
     Link for reference https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly


### Inputs from module:

The variables that are passed to module internally. These can be overwritten when calling module from outside. These are:

|Module Parameter|Type|Required|Default Value|Valid Values|Description|
|-|-|-|-|-|-
|region|string|YES|`null`|`AWS values`|This is region where module is to be deployed
|cluster_id|string|YES|`null`|`any`|Name of the cluster in lowercase
|engine|string|YES|`redis`|`redis`|(Required unless replication_group_id is provided) Name of the cache engine to be used for this cache cluster. Only valid parameter is redis.
|node_type|string|YES|`cache.t3.micro`|`cache.*`|(Required unless replication_group_id is provided) The compute and memory capacity of the nodes. See Available Cache Node Types for supported node types.
#|num_cache_nodes|integer|NO|`1`|`any`|(Required unless replication_group_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. If this number is reduced on subsequent runs, the highest numbered nodes will be removed.
|parameter_group_name|string|YES|`default.redis5.0.cluster.on`|`AWS values`|(Required unless replication_group_id is provided) Name of the parameter group to associate with this cache cluster. Default = default.redis5.0.cluster.on
#|container_insights|bool|NO|`false`|`true/false`|Controls if ECS Cluster has container insights enabled
|engine_version|integer|NO|`5.0.6`|`AWS values`|Version number of the cache engine to be used. See Describe Cache Engine Versions in the AWS Documentation center for supported versions.
|port|integer|YES|`6379`|`[0-65554]`|Listener Port
|maintenance_window|date|NO|`sat:03:30-sun:01:00`|`day:HH:MM-day:HH:MM`| Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00. Default = sat:03:30-sun:01:00
|snapshot_retention_limit|integer|NO|`3`|`^[0-9][0-9]$`| The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. Allowd values between [0-99]. Note: snapshot_retention_limit > 0 & node_type = "cache.t1.micro" is not allowed.
|snapshot_window|date|NO|`01:30-03:20`|`HH:MM-HH:MM`| The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster
|cluster_mode_enabled|bool|NO|`false`|`true/false`| Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 cluster_mode block is allowed	
|automatic_failover_enabled|bool|NO|`true`|`true/false`| Automatic failover (Not available for T1/T2 instances). Set to true when `cluster_mode_enabled` is `true` 
|cluster_size|integer|YES|`1`|`^[0-9][0-9]$`| Number of nodes in cluster. Allowed values: [0-99]. Ignored when `cluster_mode_enabled` is `true`
|multi_az_enabled|bool|NO|`false`|`true/false`| Multi AZ (Automatic Failover must also be enabled, `automatic_failover_enabled` set to `true` . If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored)	
|transit_encryption_enabled|bool|NO|`true`|`true/false`| Enable TLS
|auth_token|string|NO|`null`|`any`| Auth token for password protecting redis, it's required `transit_encryption_enabled` set to true. Password must be longer than 16 chars. Redis Auth can only be enabled within an Amazon VPC
|cluster_mode_replicas_per_node_group|integer|YES|`1`|`^[0-5]$`| Number of replica nodes in each node group. Valid values in range [0-5]. Changing this number will force a new resource
|cluster_mode_num_node_groups|integer|YES|`1`|`^[1-9]$`|  Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. Valid values in range [0-9].
|kms_key_id|string|NO|`null`|`any`|  The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled` set to true. By default module will create a new CMK, alias it and when `at_rest_encryption_enabled` set to true.
|enable_kms_key_rotation|bool|NO|`false`|`true/false`| Disabled by default (set to false by default). Set to true, to enable kms key rotation.
|add_subnet_group|bool|NO|`true`|`true/false`| Set to true, if want to add existing elastic subnet group or create new elastic subnet group. Set to false, if dont want to create new subnet group or use existing subnet group.
|subnet_list_to_add_to_subnet_group|list|NO|`[]`|`["subnetID-01","subnetID-02"...]`| List of subnet IDs to add to subnet group for Redis
|elasticache_existing_subnet_group_name|string|NO|`""`|`any`| Existing elastic Subnet group name for the ElastiCache instance
|vpc_id_for_sg|string|YES|`""`|`any`| VPC ID for Security Group
|use_existing_security_groups|bool|NO|`false`|`true/false`| Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into.
|existing_security_groups|list|NO|`[]`|`["sg-01","sg-02"...]`| List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster
|allowed_security_groups|list|NO|`[]`|`["sg-01","sg-02"...]`| List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module. These are added as Source security groups
|allowed_cidr_blocks|list|NO|`[]`|`["cidr-01"]`| List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module
|allowed_prefix_list|list|NO|`[]`|`["pl-xxxxx"]`| List of prefix lists that are allowed ingress to the cluster's Security Group created in the module

### Outputs from module: 
Below outputs can be exported from module:

- `subnet_group_name` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - Name of subnet group created
- `replication_group_id` &nbsp;&nbsp;&nbsp;&nbsp; - The ID of the ElastiCache Replication Group.
- `configuration_endpoint_address` &nbsp;&nbsp;&nbsp;&nbsp; - The address of the replication group configuration endpoint when cluster mode is enabled.
- `primary_endpoint_address` &nbsp;&nbsp;&nbsp;&nbsp; - The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled.
- `member_clusters` &nbsp;&nbsp;&nbsp;&nbsp; - The identifiers of all the nodes that are part of this replication group.


## Sections to be added to module caller's main.tf, variables.tf, and output.tf below:

#### Example with with default VPC and new elastic Subnet groups
```
module "aws_redis_module" {
  source = "git@github.com:capterra/terraform.git//modules/elasticache/redis"

  #Elasticache vars
  region                     = var.region
  cluster_id                 = "mydemo-myrediscluster"
  transit_encryption_enabled = true

  vpc_id_for_sg                           = "vpc-fad17781"
  use_existing_security_groups            = false
  add_subnet_group                        = false
  elasticache_existing_subnet_group_name  = ""
  subnet_list_to_add_to_subnet_group      = []

  ##### with single node, Multi-AZ and Auto-failover support 
  cluster_size               = 1
  multi_az_enabled           = true
  automatic_failover_enabled = true
  cluster_mode_enabled       = true

}
```
#### Example with custom VPC, Security Groups and default elastic Subnet groups. Include cluster mode ON
```
module "aws_redis_module" {
  source = "git@github.com:capterra/terraform.git//modules/elasticache/redis"

  #Elasticache vars
  region                     = var.region
  cluster_id                 = "mydemo-myrediscluster"
  transit_encryption_enabled = true

  ##### with custom VPC, Security Groups and default elastic Subnet groups
  vpc_id_for_sg       = module.vpc_elasticache.vpc_id
  allowed_cidr_blocks = [module.vpc_elasticache.vpc_cidr_block]
  
  use_existing_security_groups = true
  existing_security_groups     = [module.vpc_elasticache.default_security_group_id]

  add_subnet_group                       = true
  elasticache_existing_subnet_group_name = ""
  subnet_list_to_add_to_subnet_group     = module.vpc_elasticache.private_subnets

  ##### with multi node, Multi-AZ and Auto-failover support 
  cluster_size               = 3
  multi_az_enabled           = true
  automatic_failover_enabled = true
  cluster_mode_enabled       = false
}
```

### How to fetch output from Module: 
#### Include Below section to caller's output.tf file to get the module output. "aws_redis_module" is the reference used while calling module. Sample Below-
```  
output "subnet_group_name" {
  value = "${module.aws_redis_module.subnet_group_name}"
  description = "Name of subnet group created"
}

output "replication_group_id" {
  value = "${module.aws_redis_module.replication_group_id}"
  description = "The ID of the ElastiCache Replication Group."
}

output "configuration_endpoint_address" {
  value = "${module.aws_redis_module.configuration_endpoint_address}"
  description = "The address of the replication group configuration endpoint when cluster mode is enabled."
}

output "primary_endpoint_address" {
  value = "${module.aws_redis_module.primary_endpoint_address}"
  description = "(Redis only) The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value = "${module.aws_redis_module.member_clusters}"
  description = "The identifiers of all the nodes that are part of this replication group."
}
```
