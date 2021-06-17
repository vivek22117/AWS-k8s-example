####################################################
#             EKS read only Group & Policy         #
####################################################
resource "aws_iam_group" "eks_access_group" {
  name = var.eks-iam-group
  path = "/"
}

resource "aws_iam_policy" "eks_read_policy" {
  name        = "EKSReadOnlyPolicy"

  description = "EKS read only access"
  policy      = data.template_file.ecs_read_only_template.rendered
}

resource "aws_iam_group_policy_attachment" "eks_read_access_att" {

  group      = aws_iam_group.eks_access_group.name
  policy_arn = aws_iam_policy.eks_read_policy.arn
}


####################################################
#          EKS read only Role/User & Policy        #
####################################################
resource "aws_iam_role" "eks_read_role" {
  name = "EKSReadOnlyRoleForEC2"
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

resource "aws_iam_role_policy_attachment" "ecs_read_policy_role_att" {
  policy_arn = aws_iam_policy.eks_read_policy.arn
  role       = aws_iam_role.eks_read_role.name
}


resource "aws_iam_role" "eks_user_role" {
  name = "EKSReadOnlyRoleForUser"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
               "AWS": [
                  "arn:aws:iam::123456789012:root"
                ]
            },
            "Condition": { "Bool": { "aws:MultiFactorAuthPresent": "true" } }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_read_policy_user_att" {
  policy_arn = aws_iam_policy.eks_read_policy.arn
  role       = aws_iam_role.eks_user_role.name
}


####################################################
#           EKS full access User & Policy          #
####################################################
resource "aws_iam_policy" "eks_full_access_policy" {
  name        = "EKSFullAccessPolicy"

  description = "EKS full access"
  policy      = data.template_file.ecs_full_access_template.rendered
}


resource "aws_iam_role" "eks_full_access_role" {
  name = "EKSFullAccessRoleForEC2"
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

resource "aws_iam_role_policy_attachment" "ecs_admin_policy_role_att" {
  policy_arn = aws_iam_policy.eks_full_access_policy.arn
  role       = aws_iam_role.eks_full_access_role.name
}
