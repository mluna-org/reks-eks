resource "aws_route53_zone" "external" {
  name    = var.external_zone_name
  comment = "External hosted zone for EKS cluster"
  tags    = var.tags
}

resource "aws_route53_zone" "internal" {
  name    = replace(var.internal_zone_name, "ENV", var.tags["environment"])
  comment = "Private hosted zone for EKS cluster"
  tags    = var.tags

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "internal" {
  zone_id = aws_route53_zone.internal.zone_id
  vpc_id  = var.vpc_id
}