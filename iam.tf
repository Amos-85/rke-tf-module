module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 2.0"

  name = "k8s-aws-policy"
  path        = "/"
  description = "This IAM policies for ec2 nodes"

  policy =  <<EOF
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
    "autoscaling:TerminateInstanceInAutoScalingGroup",
    "autoscaling:DescribeTags",
    "ec2:DescribeTags",
    "ec2:DeleteTags",
    "ec2:DescribeInstances",
    "ec2:DescribeRegions",
    "ec2:DescribeRouteTables",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeSubnets",
    "ec2:DescribeVolumes",
    "ec2:CreateSecurityGroup",
    "ec2:CreateTags",
    "ec2:CreateSnapshot",
    "ec2:DeleteSnapshot",
    "ec2:DescribeSnapshots",
    "ec2:CreateVolume",
    "ec2:ModifyInstanceAttribute",
    "ec2:ModifyVolume",
    "ec2:AttachVolume",
    "ec2:AuthorizeSecurityGroupIngress",
    "ec2:CreateRoute",
    "ec2:DeleteRoute",
    "ec2:DeleteSecurityGroup",
    "ec2:DeleteVolume",
    "ec2:DetachVolume",
    "ec2:RevokeSecurityGroupIngress",
    "ec2:DescribeVpcs",
    "elasticloadbalancing:AddTags",
    "elasticloadbalancing:AttachLoadBalancerToSubnets",
    "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
    "elasticloadbalancing:CreateLoadBalancer",
    "elasticloadbalancing:CreateLoadBalancerPolicy",
    "elasticloadbalancing:CreateLoadBalancerListeners",
    "elasticloadbalancing:ConfigureHealthCheck",
    "elasticloadbalancing:DeleteLoadBalancer",
    "elasticloadbalancing:DeleteLoadBalancerListeners",
    "elasticloadbalancing:DescribeLoadBalancers",
    "elasticloadbalancing:DescribeLoadBalancerAttributes",
    "elasticloadbalancing:DetachLoadBalancerFromSubnets",
    "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
    "elasticloadbalancing:ModifyLoadBalancerAttributes",
    "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
    "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
    "elasticloadbalancing:AddTags",
    "elasticloadbalancing:CreateListener",
    "elasticloadbalancing:CreateTargetGroup",
    "elasticloadbalancing:DeleteListener",
    "elasticloadbalancing:DeleteTargetGroup",
    "elasticloadbalancing:DescribeListeners",
    "elasticloadbalancing:DescribeLoadBalancerPolicies",
    "elasticloadbalancing:DescribeTargetGroups",
    "elasticloadbalancing:DescribeTargetHealth",
    "elasticloadbalancing:ModifyListener",
    "elasticloadbalancing:ModifyTargetGroup",
    "elasticloadbalancing:RegisterTargets",
    "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
    "iam:CreateServiceLinkedRole",
    "kms:DescribeKey"
      ],
      "Resource": [
          "*"
      ]
    },
    {
    "Sid": "ListObjectsInBucket",
    "Effect": "Allow",
    "Action": ["s3:ListBucket"],
    "Resource": "arn:aws:s3:::${lookup(var.s3-backup-config, "bucket_name", null)}"
  },
  {
    "Sid": "AllObjectActions",
    "Effect": "Allow",
    "Action": "s3:*Object",
    "Resource": "arn:aws:s3:::${lookup(var.s3-backup-config, "bucket_name", null)}/*"
    }
  ]
}
EOF
}

module "iam_assumable_role_custom" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"
  role_description = "This IAM Role for ec2 nodes that running k8s"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role = true

  role_name         = "k8s"
  role_requires_mfa = false

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
  tags = {
    Terraform   = local.common-tags.Terraform
    Environment = local.common-tags.Environment
    Owner       = local.common-tags.Owner
  }
}

resource "aws_iam_instance_profile" "ec2_k8s_profile" {
  name_prefix = "k8s"
  role = module.iam_assumable_role_custom.this_iam_role_name
}