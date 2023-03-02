data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# EKS Data
data "aws_eks_cluster" "default" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks_cluster.cluster_id
}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_cluster["cluster_version"]}-v*"]
  }
}