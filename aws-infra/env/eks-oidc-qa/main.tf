####################################################
#        Dev EKS-VPC moudle configuration          #
####################################################
module "eks-vpc-dev" {
  source = "../../modules/eks-oidc"

  profile        = var.profile
  environment    = var.environment
  default_region = var.default_region

}
