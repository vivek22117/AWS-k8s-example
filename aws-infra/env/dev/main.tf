####################################################
#        Dev EKS-VPC moudle configuration              #
####################################################
module "eks-vpc-dev" {
  source = "../../modules/vpc"

  profile        = var.profile
  environment    = var.environment
  default_region = var.default_region

  cluster_name = var.cluster_name
  db_subnet_gp = var.db_subnet_gp

  cidr_block            = var.cidr_block
  private_azs_with_cidr = var.private_azs_with_cidr
  public_azs_with_cidr  = var.public_azs_with_cidr
  db_azs_with_cidr      = var.db_azs_with_cidr
  instance_tenancy      = var.instance_tenancy
  enable_dns            = var.enable_dns
  support_dns           = var.support_dns
  enable_nat_gateway    = var.enable_nat_gateway

  team         = var.team
  owner        = var.owner
  isMonitoring = var.isMonitoring

  bastion_instance_type = var.bastion_instance_type
  spot_allocation_st    = var.spot_allocation_st
  spot_price            = var.spot_price

  eks_cluster_name = var.eks_cluster_name
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access = var.endpoint_public_access
  node_group_name = var.node_group_name
  ami_type = var.ami_type
  disk_size = var.disk_size
  instance_types = var.instance_types
  pvt_desired_size = var.pvt_desired_size
  pvt_max_size = var.pvt_max_size
  pvt_min_size = var.pvt_min_size
  public_desired_size = var.public_desired_size
  public_max_size = var.public_max_size
  public_min_size = var.public_max_size
}
