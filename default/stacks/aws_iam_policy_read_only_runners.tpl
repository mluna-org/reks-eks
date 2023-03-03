{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage",
        "eks:DescribeCluster",
        "eks:DescribeNodegroup",
        "eks:DescribeUpdate",
        "eks:ListClusters",
        "eks:ListNodegroups",
        "eks:ListTagsForResource"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": "sts:TagSession",
      "Resource":"*"
    },
    {
      "Effect":"Allow",
      "Action": "ssm:GetParameter*",
      "Resource": ${ssm_parameter_store_prefixes}
    }
  ]
}
