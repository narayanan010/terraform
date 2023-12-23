/* This file isn't used by Terraform */

CREATE EXTERNAL TABLE `logs_all`(
  `date` date, 
  `time` string, 
  `location` string, 
  `bytes` bigint, 
  `request_ip` string, 
  `method` string, 
  `host` string, 
  `uri` string, 
  `status` int, 
  `referrer` string, 
  `user_agent` string, 
  `query_string` string, 
  `cookie` string, 
  `result_type` string, 
  `request_id` string, 
  `host_header` string, 
  `request_protocol` string, 
  `request_bytes` bigint, 
  `time_taken` float, 
  `xforwarded_for` string, 
  `ssl_protocol` string, 
  `ssl_cipher` string, 
  `response_result_type` string, 
  `http_version` string, 
  `fle_status` string, 
  `fle_encrypted_fields` int, 
  `c_port` int, 
  `time_to_first_byte` float, 
  `x_edge_detailed_result_type` string, 
  `sc_content_type` string, 
  `sc_content_len` bigint, 
  `sc_range_start` bigint, 
  `sc_range_end` bigint)
PARTITIONED BY (
  `account_id` string,
  `distribution_id` string,
  `datehour` string
)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '\t' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://capterra-cloudfront-logs/'
TBLPROPERTIES (
 'projection.account_id.type'='enum',
 'projection.account_id.values'='148797279579,176540105868,273213456764',
 'projection.datehour.format'='yyyy/MM/dd/HH',
 'projection.datehour.interval'='1',
 'projection.datehour.interval.unit'='HOURS',
 'projection.datehour.range'='2021/10/01/00,NOW',
 'projection.datehour.type'='date', 
 'projection.distribution_id.type'='injected', 
 'projection.enabled'='true', 
 'skip.header.line.count'='2', 
 'storage.location.template'='s3://capterra-cloudfront-logs/${account_id}/${distribution_id}/'
)
