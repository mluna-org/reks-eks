{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow administration of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion",
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:TagResource",
            "kms:UntagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow usage of the key",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : "arn:aws:iam::${account_id}:root"
            },
            "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
            ],
            "Resource" : "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${region}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnLike": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${region}:${account_id}:*"
                }
            }
        } 
    ]
}
