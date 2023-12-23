Please, beware, that zip file contains installed [requirements.txt](https://github.com/newrelic/aws_s3_log_ingestion_lambda/blob/b51a0878a55a9189afbb2bbf4a3d75b72186dfb9/requirements.txt), that is not a part of core Python.
To recreate zip file, use this command (with precompiled libraries (you may use virtualenv for that)):
```zip cloudfront_logs_push_to_newrelic.zip -r aiohttp multidict attr yarl idna async_timeout chardet smart_open boto pympler cloudfront_logs_push_to_newrelic.py```

File is stored at s3://capterra-lambda-zips/cloudfront_logs_push_to_newrelic.zip
