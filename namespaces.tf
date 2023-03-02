resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}