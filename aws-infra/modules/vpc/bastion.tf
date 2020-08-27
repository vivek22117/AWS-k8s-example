########################################################
#    Key pair to be used for different applications    #
########################################################
resource "aws_key_pair" "bastion_key" {
  public_key = var.public_key
  key_name   = "bastion-key"
}


##################################################################
#   Bastion host launch template and act as Jump Instance        #
##################################################################
resource "aws_launch_template" "eks_bastion_lt" {
  iam_instance_profile {
    name = aws_iam_instance_profile.bastion_host_profile.name
  }
  image_id               = data.aws_ami.bastion.id
  name                   = "eks-bastion-host"
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name
  instance_type          = var.bastion_instance_type

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 10
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


#################################################
#         Bastion host ASG                      #
#################################################
resource "aws_autoscaling_group" "bastion_asg" {
  name = "eks-bastion-asg"

  vpc_zone_identifier = aws_subnet.public.*.id
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_instance_pools                      = 2
      spot_allocation_strategy                 = var.spot_allocation_st
      spot_max_price                           = var.spot_price
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_bastion_lt.id
        version            = "$Latest"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
