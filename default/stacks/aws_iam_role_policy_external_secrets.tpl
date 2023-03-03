{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "arn:aws:secretsmanager:${region}:${account_id}:secret:/${environment}/eks/*",
        "arn:aws:secretsmanager:${region}:${account_id}:secret:/${environment}/github/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameter",
      "Resource": [
        "arn:aws:ssm:${region}:${account_id}:parameter/${environment}/eks/*",
        "arn:aws:ssm:${region}:${account_id}:parameter/${environment}/github/*"
      ]
    }
  ]
}
