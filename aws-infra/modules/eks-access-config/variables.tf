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


######################################################################
# Global variables for VPC, Subnet, Routes and Bastion Host          #
######################################################################
variable "bastion_instance_type" {
  type        = string
  description = "Instance type for Bastion Host"
}

variable "spot_allocation_st" {
  type        = string
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized."
}

variable "spot_price" {
  type = string
  description = "EC2 Spot price"

}
######################################################
# Local variables defined                            #
######################################################
variable "team" {
  type        = string
  description = "Owner team for this application infrastructure"
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
  description = "Monitoring is enabled or disabled for the resources creating"
}

variable "eks-iam-group" {
  type = string
  description = "Name of the EKS group"
}

#####=============================BastionHost Configuration Variables========================#####
variable "public_key" {
  type        = string
  description = "key pair value"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDV3fznjm92/s10goG0YotNIjq66CTDyf5a6wVVQUDYIF4OziH9G81NNc9sQiTlfNFy8RO4kSB0n5+w9nt90gs7nSZoBAATK6T0YNHll/A6ISUv4hgwooa6XUYxFgg+ceZ8Mvxc36wx78wTieVc7RTbx74Wr8AtavSJMC8wVb8QkUGMpumH7TNPP356MYEEgYciRLE8sLnkRYOvVekL3iU8p1tS5Pny5mqR1hinbQoE7WNuDsBxgV6Xn9kRQ9Rn5seIyY55tc1HPd2fwkafidWVX3hUD8RwOfSYvAwPc7AmVLCbUCktSZ8S1FEV9dSVncd8ji1tguoHh/OquXzNckqJ vivek@LAPTOP-FLDAPLLM"
}


variable "eks_bastion_asg_max_size" {
  type        = string
  description = "ASG max size"
}

variable "eks_bastion_asg_min_size" {
  type        = string
  description = "ASG min size"
}

variable "eks_bastion_asg_desired_capacity" {
  type        = string
  description = "ASG desired capacity"
}

variable "default_cooldown" {
  type        = number
  description = "Cool down value of ASG"
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  type        = list(string)
}

variable "app_instance_name" {
  type        = string
  description = "Instance name tag to propagate"
}


variable "resource_name_prefix" {
  type        = string
  description = "Application resource name prefix"
}

variable "ami_id" {
  type        = string
  description = "AMI id to create EC2"
}

variable "instance_type" {
  type        = string
  description = "Instance type to launc EC2"
}

variable "key_name" {
  type        = string
  description = "Key pair to use SSh access"
}

variable "volume_size" {
  type        = string
  description = "Volume size"
}

variable "max_price" {
  type        = string
  description = "Spot price for EC2 instance"
}

variable "instance_tenancy" {
  type        = string
  description = "Type of EC2 instance tenancy 'default' or 'dedicated'"
}

variable "target_type" {
  type        = string
  description = "Target group instance type 'ip', 'instance', 'lambda'"
}

#####=============Local & Default Variables===============#####

variable "dyanamoDB_prefix" {
  type    = string
  default = "doubledigit-tfstate"
}

variable "s3_bucket_prefix" {
  type    = string
  default = "doubledigit-tfstate"
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
    ssm-session = "enabled"
  }
}

locals {
  common_tags = {
    owner       = var.owner
    team        = var.team
    environment = var.environment
    monitoring  = var.isMonitoring
    Project     = "DD-Solutions"
  }
}