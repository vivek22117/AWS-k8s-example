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