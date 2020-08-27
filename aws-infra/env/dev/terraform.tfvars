profile        = "qa-admin"
default_region = "us-east-1"
cluster_name   = "doubledigit-eks"

cidr_block         = "10.11.0.0/20"
instance_tenancy   = "default"
enable_dns         = "true"
support_dns        = "true"
enable_nat_gateway = true
db_subnet_gp       = "eks-dbsubnet-group"

spot_allocation_st = "lowest-price"
spot_price         = "0.007200"


private_azs_with_cidr = {
  us-east-1a = "10.11.0.0/24"
  us-east-1b = "10.11.2.0/24"
  us-east-1c = "10.11.4.0/24"
}

public_azs_with_cidr = {
  us-east-1a = "10.11.1.0/24"
  us-east-1b = "10.11.3.0/24"
  us-east-1c = "10.11.5.0/24"
}

db_azs_with_cidr = {
  us-east-1a = "10.11.6.0/24"
  us-east-1b = "10.11.7.0/24"
  us-east-1c = "10.11.8.0/24"
}


team                  = "DoubleDigitTeam"
owner                 = "Vivek"
bastion_instance_type = "t3.small"
isMonitoring          = true


eks_cluster_name = "DD-EKS"
endpoint_private_access = false
endpoint_public_access = true
node_group_name = "DD-NodeGroup-11"
ami_type = "AL2_x86_64"
disk_size = 10
instance_types = ["t3.medium"]
pvt_desired_size = 1
pvt_max_size = 1
pvt_min_size = 1
public_desired_size = 1
public_max_size = 1
public_min_size = 1