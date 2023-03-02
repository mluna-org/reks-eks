// stores EKS cluster name in an SSM parameter
// to be used by pipelines and roles between others...
resource "aws_ssm_parameter" "eks_cluster" {
  name      = "/${var.tags["prefix"]}/eks/cluster_id"
  type      = "String"
  overwrite = true
  value     = module.eks_cluster.cluster_id
  tags      = var.tags
}
