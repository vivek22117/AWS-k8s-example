data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}


provider "kubernetes" {
  host                   = aws_eks_cluster.doubledigit_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.doubledigit_eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode()
  }
}