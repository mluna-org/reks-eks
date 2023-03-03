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

### ROUTE53

output "public_zone_id" {
  value = aws_route53_zone.external.zone_id
}

output "public_zone_domain" {
  value = aws_route53_zone.external.name
}

output "private_zone_id" {
  value = aws_route53_zone.internal.zone_id
}

output "private_zone_domain" {
  value = aws_route53_zone.internal.name
}

### KMS

output "ebs_kms_arn" {
  value = var.kms_ebs.create_kms_key ? aws_kms_key.kms_ebs[0].arn : null
}

output "ecr_kms_arn" {
  value = var.kms_ecr.create_kms_key ? aws_kms_key.kms_ecr[0].arn : null
}
