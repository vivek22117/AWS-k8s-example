#################################################
#       VPC Configuration                       #
#################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.support_dns


  tags = merge(local.common_tags, {
  "Name" = "eks-vpc-${var.environment}-${var.cidr_block}"
  "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  "alpha.eksctl.io/cluster-name"= var.cluster_name
  "eksctl.cluster.k8s.io/v1alpha5/cluster-name"=var.cluster_name
  })
}

#######################################################
# Enable access to or from the Internet for instances #
# in public subnets using IGW                         #
#######################################################
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
    "Name" = "eks-igw-${var.environment}"
    "alpha.eksctl.io/cluster-name"                =  var.cluster_name
    "eksctl.cluster.k8s.io/v1alpha5/cluster-name" =  var.cluster_name
    })
}

########################################################################
# Route Table                                                          #
## Usually unecessary to explicitly create a Route Table in Terraform  #
## since AWS automatically creates and assigns a 'Main Route Table'    #
## whenever a VPC is created. However, in a Transit Gateway scenario,  #
## Route Tables are explicitly created so an extra route to the        #
## Transit Gateway could be defined                                    #
########################################################################
resource "aws_route_table" "vpc_main_rt" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, {
    "Name" = "eks-vpc-${var.environment}-main-rt"
    "alpha.eksctl.io/cluster-name"                =  var.cluster_name
    "eksctl.cluster.k8s.io/v1alpha5/cluster-name" =  var.cluster_name
  })
}

resource "aws_main_route_table_association" "main_rt_vpc" {
  route_table_id = aws_route_table.vpc_main_rt.id
  vpc_id         = aws_vpc.vpc.id
}

