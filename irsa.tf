locals {
  oidc = split("https://", module.eks_cluster.cluster_oidc_issuer_url)[1]
}

# OPENID-CONNECTOR definition
data "aws_iam_policy_document" "oidc" {
  for_each = var.k8s_resources
  version  = "2012-10-17"
  statement {
    sid    = replace("${each.value.serviceaccount}", "-", "")
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc}"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.oidc}:sub"
      values   = ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount}"]
    }
  }
}

# -_-_-_-_-CLUSTER-AUTOSCALER-_-_-_-_-
resource "aws_iam_role" "cluster_autoscaler" {
#  name               = "${var.tags["prefix"]}-eks-cluster-autoscaler"
  name               = "${var.tags["prefix"]}-eks-cluster-autoscaler"
  description        = "Role used by EKS Cluster Autoscaler"
  assume_role_policy = data.aws_iam_policy_document.oidc["cluster-autoscaler"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  name   = "${var.tags["prefix"]}-eks-cluster-autoscaler-policy"
  policy = var.cluster_autoscaler_policy
  role   = aws_iam_role.cluster_autoscaler.name
}

# -_-_-_-_-LOAD-BALANCER-CONTROLLER-_-_-_-_-
resource "aws_iam_role" "load_balancer_controller" {
  name               = "${var.tags["prefix"]}-eks-load-balancer-controller"
  description        = "Role used by AWS Load Balancer Controller"
  assume_role_policy = data.aws_iam_policy_document.oidc["load-balancer-controller"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "load_balancer_controller" {
  name   = "${var.tags["prefix"]}-eks-lb-controller-policy"
  policy = var.load_balancer_controller_policy
  role   = aws_iam_role.load_balancer_controller.name
}

# -_-_-_-_-CLOUDWATCH-EXPORTER-_-_-_-_-
resource "aws_iam_role" "cloudwatch_exporter" {
  name               = "${var.tags["prefix"]}-eks-cloudwatch-exporter"
  description        = "Role used by EKS Cloudwatch Exporter"
  assume_role_policy = data.aws_iam_policy_document.oidc["cloudwatch-exporter"].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_exporter" {
  role       = aws_iam_role.cloudwatch_exporter.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# -_-_-_-_-EXTERNAL-SECRETS-_-_-_-_-
resource "aws_iam_role" "external_secrets" {
  name               = "${var.tags["prefix"]}-eks-external-secrets"
  description        = "Role used by EKS External Secrets"
  assume_role_policy = data.aws_iam_policy_document.oidc["external-secrets"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "external_secrets" {
  name   = "${var.tags["prefix"]}-eks-external-secrets-policy"
  policy = var.external_secrets_policy
  role   = aws_iam_role.external_secrets.name
}

# -_-_-_-_-EXTERNAL-DNS-_-_-_-_-
resource "aws_iam_role" "external_dns" {
  name               = "${var.tags["prefix"]}-eks-external-dns"
  description        = "Role used by External DNS"
  assume_role_policy = data.aws_iam_policy_document.oidc["external-dns"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "external_dns" {
  name   = "${var.tags["prefix"]}-eks-external-dns"
  policy = var.external_dns_policy
  role   = aws_iam_role.external_dns.name
}

# -_-_-_-_-FLUENTBIT-_-_-_-_-
resource "aws_iam_role" "fluent_bit" {
  name               = "${var.tags["prefix"]}-eks-fluent-bit"
  description        = "Role used by Fluent-bit"
  assume_role_policy = data.aws_iam_policy_document.oidc["fluent-bit"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "fluent_bit" {
  name   = "${var.tags["prefix"]}-fluent-bit"
  policy = var.fluent_bit_policy
  role   = aws_iam_role.fluent_bit.name
}

# -_-_-_-_-EBS-CSI-CONTROLLER-_-_-_-_-
resource "aws_iam_role" "ebs_csi_controller" {
  name               = "${var.tags["prefix"]}-eks-ebs-csi-controller"
  description        = "Role used by EKS EBS CSI Controller"
  assume_role_policy = data.aws_iam_policy_document.oidc["ebs-csi-controller"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "ebs_csi_controller_policy" {
  name   = "${var.tags["prefix"]}-eks-ebs-csi-policy"
  policy = var.ebs_csi_policy
  role   = aws_iam_role.ebs_csi_controller.name
}

# -_-_-_-_-EFS-CSI-CONTROLLER-_-_-_-_-
resource "aws_iam_role" "efs_csi_controller" {
  name               = "${var.tags["prefix"]}-eks-efs-csi-controller"
  description        = "Role used by EKS EFS CSI Controller"
  assume_role_policy = data.aws_iam_policy_document.oidc["efs-csi-controller"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "efs_csi_controller_policy" {
  name   = "${var.tags["prefix"]}-eks-efs-csi-policy"
  policy = var.efs_csi_policy
  role   = aws_iam_role.efs_csi_controller.name
}

# -_-_-_-_- Vault -_-_-_-_-
resource "aws_iam_role" "vault" {
  name               = "${var.tags["prefix"]}-vault"
  description        = "Role used by Vault in k8s"
  assume_role_policy = data.aws_iam_policy_document.oidc["vault"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "vault_policy" {
  name   = "${var.tags["prefix"]}-eks-vault-policy"
  policy = var.vault_policy
  role   = aws_iam_role.vault.name
}

resource "aws_iam_role" "jenkins" {
  count              = var.environment == "ops" ? 1 : 0
  name               = "${var.tags["prefix"]}-jenkins"
  description        = "Role used by jenkins in k8s"
  assume_role_policy = data.aws_iam_policy_document.oidc["jenkins"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "jenkins" {
  count  = var.environment == "ops" ? 1 : 0
  name   = "${var.tags["prefix"]}-eks-jenkins-policy"
  policy = var.jenkins_policy
  role   = aws_iam_role.jenkins[0].name
}

# -_-_-_-_-Nexus-_-_-_-_-
resource "aws_iam_role" "nexus" {
  count              = var.environment == "ops" ? 1 : 0
  name               = "${var.tags["prefix"]}-nexus"
  description        = "Role used by nexus in k8s"
  assume_role_policy = data.aws_iam_policy_document.oidc["nexus"].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "nexus" {
  count  = var.environment == "ops" ? 1 : 0
  name   = "${var.tags["prefix"]}-eks-nexus-policy"
  policy = var.nexus_policy
  role   = aws_iam_role.nexus[0].name
}

