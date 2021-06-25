####################
## OpenID Connect ##
####################
data "tls_certificate" "eks_cluster_cert" {
  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer
}


resource "aws_iam_openid_connect_provider" "main" {
  url = aws_eks_cluster.doubledigit_eks.identity.0.oidc.0.issuer
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    data.tls_certificate.eks_cluster_cert.eks_cluster_cert.0.sha1_fingerprint
  ]
}
################
## IAM Policy ##
################
resource "aws_iam_policy" "main" {
  name = var.policy_name
  path = "/"
  description = "Allow AWS EKS PODs to get a specify S3 Object"
  policy = file("${path.module}/policies/s3_policy.json")
}
resource "aws_iam_role" "main" {
  name = var.role_name
  path = "/"
  assume_role_policy = data.template_file.role_trust_relationship.rendered
  force_detach_policies = false
}
resource "aws_iam_role_policy_attachment" "main" {
  role = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
############
## K8s SA ##
############
resource "kubernetes_service_account" "main" {
  metadata {
    name = var.role_name
    namespace = "matheus"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.main.arn
    }
  }
  automount_service_account_token = true
}