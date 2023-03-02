module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.23.0"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

####
#### CAMBIAR
####

  #cluster_name                    = "pepito"

####
#### FIN CAMBIAR
####

  cluster_name                    = var.eks_cluster["name"]
  cluster_version                 = var.eks_cluster["cluster_version"]
  cluster_endpoint_private_access = var.eks_cluster["cluster_endpoint_private_access"]
  cluster_endpoint_public_access  = var.eks_cluster["cluster_endpoint_public_access"]
  cluster_enabled_log_types       = var.eks_cluster["cluster_enabled_log_types"]
  enable_irsa                     = var.eks_cluster["enable_irsa"]

  cloudwatch_log_group_kms_key_id = var.kms_keys["cloudwatch"]

  manage_aws_auth_configmap = var.eks_cluster["manage_aws_auth"]
  aws_auth_users            = var.eks_cluster["aws_auth_users"]
  aws_auth_roles            = var.eks_cluster["aws_auth_roles"]

  node_security_group_additional_rules = var.node_security_group_additional_rules

  eks_managed_node_groups = var.node_groups
  eks_managed_node_group_defaults = {

    ami_type       = var.eks_cluster["default_ami_type"]
    instance_types = var.eks_cluster["default_instance_types"]

    # We are using the IRSA created below for permissions
    # However, we have to deploy with the policy attached FIRST (when creating a fresh cluster)
    # and then turn this off after the cluster/node group is created. Without this initial policy,
    # the VPC CNI fails to assign IPs and nodes cannot join the cluster
    # See https://github.com/aws/containers-roadmap/issues/1666 for more context
    iam_role_attach_cni_policy = true
  }

  tags = var.tags
}

resource "aws_security_group_rule" "client_vpn_access" {
  count             = var.eks_cluster["cluster_endpoint_private_access"] == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["172.30.0.0/17"]
  security_group_id = module.eks_cluster.cluster_security_group_id
}

resource "aws_security_group_rule" "devops_cluster_access" {
  count             = var.eks_cluster["cluster_endpoint_private_access"] == true ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["172.27.224.0/20"]
  security_group_id = module.eks_cluster.cluster_security_group_id
}