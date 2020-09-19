######################################################################
# Global variables for VPC, Subnet, Routes and Bastion Host          #
######################################################################
variable "profile" {
  type        = string
  description = "AWS Profile name for credentials"
}

variable "default_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "cidr_block" {
  type        = string
  description = "Cidr range for vpc"
}

variable "instance_tenancy" {
  type        = string
  description = "Type of instance tenancy required default/dedicated"
}

variable "enable_dns" {
  type        = string
  description = "To use private DNS within the VPC"
}

variable "support_dns" {
  type        = string
  description = "To use private DNS support within the VPC"
}

variable "private_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for infrastructure"
}

variable "public_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for infrastructure"
}

variable "db_azs_with_cidr" {
  type        = map(string)
  description = "Name of azs with cidr to be used for Database infrastructure"
}

variable "db_subnet_gp" {
  type        = string
  description = "DB subnet group name for RDS and Aurora instances"
}

variable "enable_nat_gateway" {
  type        = string
  description = "want to create nat-gateway or not"
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type for Bastion Host"
}

variable "spot_allocation_st" {
  type        = string
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized."
}

variable "spot_price" {
  type        = string
  description = "EC2 Spot price"
}

#########################################################
# Default variables for backend and SSH key for Bastion #
#########################################################
variable "s3_bucket_prefix" {
  type        = string
  default     = "doubledigit-tfstate"
  description = "Prefix for s3 bucket"
}

variable "public_key" {
  type        = string
  description = "key pair value"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDV3fznjm92/s10goG0YotNIjq66CTDyf5a6wVVQUDYIF4OziH9G81NNc9sQiTlfNFy8RO4kSB0n5+w9nt90gs7nSZoBAATK6T0YNHll/A6ISUv4hgwooa6XUYxFgg+ceZ8Mvxc36wx78wTieVc7RTbx74Wr8AtavSJMC8wVb8QkUGMpumH7TNPP356MYEEgYciRLE8sLnkRYOvVekL3iU8p1tS5Pny5mqR1hinbQoE7WNuDsBxgV6Xn9kRQ9Rn5seIyY55tc1HPd2fwkafidWVX3hUD8RwOfSYvAwPc7AmVLCbUCktSZ8S1FEV9dSVncd8ji1tguoHh/OquXzNckqJ vivek@LAPTOP-FLDAPLLM"
}

######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = string
  description = "Owner team for this applcation infrastructure"
}

variable "owner" {
  type        = string
  description = "Owner of the product"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "isMonitoring" {
  type        = bool
  description = "Monitiroing is enabled or disabled for the resources creating"
}

#####=============ASG Standards Tags===============#####
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default = {
    owner      = "vivek"
    team       = "doubledigit-solutions"
    tool       = "Terraform"
    monitoring = "true"
    Name       = "Bastion-Host"
    Project    = "DoubleDigit-Solutions"
  }
}

#####=============Local variables===============#####
locals {
  common_tags = {
    owner       = var.owner
    team        = var.team
    environment = var.environment
    monitoring  = var.isMonitoring
  }
}

#####================EKS Variables======================#####
variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Amazon EKS private API server endpoint is enabled. Default is false"
}

variable "endpoint_public_access" {
  type        = bool
  description = "Amazon EKS public API server endpoint is enabled. Default is true"
}

variable "pvt_node_group_name" {
  type        = string
  description = "EKS cluster private Node Group name"
}

variable "pub_node_group_name" {
  type        = string
  description = "EKS cluster public Node Group name"
}

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes."
}

variable "instance_types" {
  type        = list(string)
  description = "Set of instance types associated with the EKS Node Group."
}

variable "pvt_desired_size" {
  type        = number
  description = "Desired number of EKS Private worker nodes."
}

variable "pvt_max_size" {
  type        = number
  description = "Maximum number of EKS Private worker nodes."
}

variable "pvt_min_size" {
  type        = number
  description = "Minimum number of EKS Private worker nodes."
}

variable "public_desired_size" {
  type        = number
  description = "Desired number of EKS Private worker nodes."
}

variable "public_max_size" {
  type        = number
  description = "Maximum number of EKS Private worker nodes."
}

variable "public_min_size" {
  type        = number
  description = "Minimum number of EKS Private worker nodes."
}

variable "log_retention" {
  type = number
  description = "Number of days to store EKS logs"
}

variable "enabled_log_types" {
  type = list(string)
  description = "Amazon EKS control plane logging provides audit and diagnostic logs directly from the Amazon EKS control plane to CloudWatch Logs"
}

variable "cluster_version" {
  type = string
  description = "Desired Kubernetes master version."
}