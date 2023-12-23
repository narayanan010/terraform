#!/bin/bash


for name in $@;
do
  if [[ ! -f "$name.zip" ]]; then
    aws s3 cp s3://capterra-lambda-zips/${name}.zip .
  fi
done
