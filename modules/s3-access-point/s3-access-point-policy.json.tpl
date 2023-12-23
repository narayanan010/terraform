{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:user/${iamusername}"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:List*"
            ],
            "Resource": "arn:aws:s3:${region_aws}:${account_id}:accesspoint/${access_point_name}/object/${bucketsubdirname}/*"
        }
    ]
}