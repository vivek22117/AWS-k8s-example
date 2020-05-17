output "vpc_id" {
  value = module.eks-vpc-dev.vpc_id
}

output "eip_ngw" {
  value = module.eks-vpc-dev.eip_ngw
}

output "private_subnets" {
  value = module.eks-vpc-dev.private_subnets
}

output "private_cidrs" {
  value = module.eks-vpc-dev.private_cirds
}

output "public_subnets" {
  value = module.eks-vpc-dev.public_subnets
}

output "public_cirds" {
  value = module.eks-vpc-dev.public_cidrs
}

output "db_subnets" {
  value = module.eks-vpc-dev.db_subnets
}

output "db_cirds" {
  value = module.eks-vpc-dev.db_cirds
}

output "private_rt" {
  value = module.eks-vpc-dev.private_rt
}

output "public_rt" {
  value = module.eks-vpc-dev.public_rt
}

output "bastion_sg" {
  value = module.eks-vpc-dev.bastion_sg_id
}

output "vpc_cidr" {
  value = module.eks-vpc-dev.vpc_cidr_block
}
