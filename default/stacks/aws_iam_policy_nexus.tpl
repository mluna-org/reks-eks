{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:GetLifecycleConfiguration",
                "s3:PutLifecycleConfiguration",
                "s3:PutObjectTagging",
                "s3:GetObjectTagging",
                "s3:DeleteObjectTagging",
                "s3:GetBucketAcl",
				"s3:DeleteBucket",
                "s3:CreateBucket"
            ],
			"Resource": [
				"arn:aws:s3:::*"
			]
		}
	]
}
