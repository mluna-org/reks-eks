output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.cluster_autoscaler.arn
}

output "load_balancer_controller_role_arn" {
  value = aws_iam_role.load_balancer_controller.arn
}

output "cloudwatch_exporter_role_arn" {
  value = aws_iam_role.cloudwatch_exporter.arn
}

output "external_secrets_role_arn" {
  value = aws_iam_role.external_secrets.arn
}

output "ebs_csi_controller_role_arn" {
  value = aws_iam_role.ebs_csi_controller.arn
}

output "efs_csi_controller_role_arn" {
  value = aws_iam_role.efs_csi_controller.arn
}

output "external_dns_role_arn" {
  value = aws_iam_role.external_dns.arn
}

output "fluent_bit_role_arn" {
  value = aws_iam_role.fluent_bit.arn
}
output "vault_role_arn" {
  value = aws_iam_role.vault.arn
}

output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks_cluster.cluster_oidc_issuer_url
}

output "cluster_oidc_issuer_url_stripped" {
  value = split("https://", module.eks_cluster.cluster_oidc_issuer_url)[1]
}

output "node_security_group_id" {
  value = module.eks_cluster.node_security_group_id
}