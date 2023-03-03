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
            "kms:TagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow usage of the key",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : "arn:aws:iam::${account_id}:user/${app_user}"
            },
            "Action": [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
            ],
            "Resource" : "*"
        }
    ]
}
