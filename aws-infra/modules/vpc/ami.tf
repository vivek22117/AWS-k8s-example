####################################################
#             Bastion host AMI for EKS             #
####################################################
data "aws_ami" "bastion" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["eks-bastion"]
  }
}


#####===========================As Of Now Not Used=================================#####
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.doubledigit_eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}