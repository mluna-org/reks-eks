locals {
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  eks_worker_default_policies = [
    "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy",
    "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "worker_group_cpu" {
  name               = "${var.eks_cluster["name"]}-${var.eks_cluster["worker_group_cpu_name"]}"
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role_policy.json
}

####
#### CAMBIAR
####


resource "aws_iam_instance_profile" "worker_group_cpu" {
  #name_prefix = "${var.eks_cluster["worker_group_cpu_name"]}"
  name_prefix = "pepe"
  role        = aws_iam_role.worker_group_cpu.id
}

####
#### FIN CAMBIAR
####

resource "aws_iam_role_policy_attachment" "worker_group_cpu" {
  count      = length(local.eks_worker_default_policies)
  role       = aws_iam_role.worker_group_cpu.name
  policy_arn = local.eks_worker_default_policies[count.index]
}

resource "aws_kms_grant" "worker_group_cpu_grant" {
  for_each          = var.kms_keys
  name              = "eks-grant-${each.key}"
  key_id            = each.value
  grantee_principal = aws_iam_role.worker_group_cpu.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey", "ReEncryptFrom", "ReEncryptTo", "DescribeKey"]
}

resource "aws_kms_grant" "asg_service_role_grant" {
  depends_on        = [module.eks_cluster]
  for_each          = var.kms_keys
  name              = "eks-asg-grant-${each.key}"
  key_id            = each.value
  grantee_principal = "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey", "ReEncryptFrom", "ReEncryptTo", "DescribeKey", "CreateGrant"]
}
