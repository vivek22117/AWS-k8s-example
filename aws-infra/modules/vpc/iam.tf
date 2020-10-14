resource "aws_iam_role" "bastion_host_role" {
  name = "BastionHostEC2RoleForEKS"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "Service": [
                  "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

#RSVP ec2 instance policy
resource "aws_iam_policy" "bastion_host_policy" {
  name        = "BastionHostEC2PolicyForEKS"
  description = "Policy to access AWS Resources"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "NavigateInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_policy_role_attach" {
  policy_arn = aws_iam_policy.bastion_host_policy.arn
  role       = aws_iam_role.bastion_host_role.name
}

resource "aws_iam_instance_profile" "bastion_host_profile" {
  name = "BastionHostInstanceProfileForEKS"
  role = aws_iam_role.bastion_host_role.name

  lifecycle {
    create_before_destroy = true
  }
}


#################################################
#       EKS Cluster IAM Role                    #
#################################################
resource "aws_iam_role" "eks_cluster_iam" {
  name               = "${var.eks_cluster_name}-cluster-${var.environment}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_iam.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_vpc_resource_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_iam.name
}


resource "aws_iam_policy" "cluster_elb_sl_policy" {
  name        = "EKSClusterELBServiceLinkedPolicy"
  description = "required to create AWSServiceRoleForElasticLoadBalancing service-linked role by EKS during ELB provisioning"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeAccountAttributes",
              "ec2:DescribeInternetGateways"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster_elb_sl_role_attach" {
  policy_arn = aws_iam_policy.cluster_elb_sl_policy.arn
  role       = aws_iam_role.eks_cluster_iam.name
}

#################################################
#       EKS Cluster Nodes IAM Role              #
#################################################
resource "aws_iam_role" "dd_eks_nodes_role" {
  name               = "${var.eks_cluster_name}-worker-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_workers.json
}

data "aws_iam_policy_document" "eks_workers" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "aws_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.dd_eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.dd_eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.dd_eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
  role       = aws_iam_role.dd_eks_nodes_role.name
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "EKSClusterAutoScaler"
  description = "Give the worker node running the Cluster Autoscaler access to required resources and actions"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
