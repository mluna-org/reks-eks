// Encrypt EBS volumes
resource "aws_kms_key" "kms_ebs" {
  count                   = var.kms_ebs.create_kms_key ? 1 : 0
  description             = "Encrypt EBS volumes used by EKS cluster"
  deletion_window_in_days = var.kms_ebs.deletion_window_in_days
  enable_key_rotation     = var.kms_ebs.enable_key_rotation
  policy                  = var.ebs_kms_policy
  tags                    = var.tags
}
resource "aws_kms_alias" "kms_ebs" {
  count         = var.kms_ebs.create_kms_key ? 1 : 0
  name          = "alias/${var.tags["prefix"]}/ebs"
  target_key_id = aws_kms_key.kms_ebs[0].id
}

// Encrypt ECR repositories
resource "aws_kms_key" "kms_ecr" {
  count                   = var.kms_ecr.create_kms_key ? 1 : 0
  description             = "Encrypt ECR repositories used by EKS cluster"
  deletion_window_in_days = var.kms_ecr.deletion_window_in_days
  enable_key_rotation     = var.kms_ecr.enable_key_rotation
  policy                  = var.generic_kms_policy
  tags                    = var.tags
}

resource "aws_kms_alias" "kms_ecr" {
  count         = var.kms_ecr.create_kms_key ? 1 : 0
  name          = "alias/${var.tags["prefix"]}/ecr"
  target_key_id = aws_kms_key.kms_ecr[0].id
}