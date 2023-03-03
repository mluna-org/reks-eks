{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${public_hosted_zone_id}",
        "arn:aws:route53:::hostedzone/${private_hosted_zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZones",
      "Resource": [
        "*"
      ]
    }
  ]
}
