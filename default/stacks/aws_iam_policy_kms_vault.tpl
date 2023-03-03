{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"kms:DescribeKey",
				"kms:Encrypt",
				"kms:Decrypt",
				"kms:ReEncrypt*",
				"kms:GenerateDataKey",
				"kms:GenerateDataKeyWithoutPlaintext"
			],
			"Resource": "*"
		}
	]
}
