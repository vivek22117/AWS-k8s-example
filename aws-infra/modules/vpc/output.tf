output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "eip_ngw" {
  value = aws_eip.nat_eip.*.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "public_cidrs" {
  value = aws_subnet.public.*.cidr_block
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "private_cirds" {
  value = aws_subnet.private.*.cidr_block
}

output "db_subnets" {
  value = aws_subnet.db_subnet.*.id
}

output "db_cirds" {
  value = aws_subnet.db_subnet.*.cidr_block
}

output "private_rt" {
  value = aws_route_table.private.*.id
}

output "public_rt" {
  value = aws_route_table.public.*.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_host_sg.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_main_rt" {
  value = aws_route_table.vpc_main_rt.id
}


output "eks_cluster_endpoint" {
  value = aws_eks_cluster.doubledigit_eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.doubledigit_eks.certificate_authority
}
