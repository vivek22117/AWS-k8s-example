#################
## EKS Cluster ##
#################
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"

  config = {
    profile = "admin"
    bucket  = "${var.s3_bucket_prefix}-${var.environment}-${var.default_region}"
    key     = "state/${var.environment}/eks-vpc/terraform.tfstate"
    region  = var.default_region
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = element(concat(data.terraform_remote_state.eks_cluster.outputs.*.id, list("")), 0) ## aws_eks_cluster.main.id
}

##################
## IAM Policies ##
##################
data "template_file" "role_trust_relationship" {
  template = file("${path.module}/policies/role_trust_relationship.json.tmpl")
  vars = {
    oidc_arn      = aws_iam_openid_connect_provider.main.arn
    oidc_url      = aws_iam_openid_connect_provider.main.url
    k8s_namespace = var.k8s_namespace
    role_name     = var.role_name
  }
}