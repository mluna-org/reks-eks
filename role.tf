resource "kubernetes_cluster_role" "read-only" {
  metadata {
    name = "read-only"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces", "nodes", "pods"]
    verbs      = ["get", "list", "watch"]
  }

}


resource "kubernetes_cluster_role_binding" "readonly-clusterrolebinding" {
  metadata {
    name = "readonly-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "read-only"
  }
  subject {
    kind      = "Group"
    name      = "Readonly-Group"
    api_group = "rbac.authorization.k8s.io"
  }

}
