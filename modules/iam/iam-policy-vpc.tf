data "aws_iam_policy_document" "student_vpc" {

  # Lecture de l'environnement réseau
  statement {
    sid    = "DescribeVPC"
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeAvailabilityZones"
    ]

    resources = ["*"]
  }

  # Création du VPC
  statement {
    sid    = "CreateVPC"
    effect = "Allow"

    actions = [
      "ec2:CreateVpc"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      
      values = var.allowed_aws_regions
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  # Création subnet
  statement {
    sid    = "CreateSubnet"
    effect = "Allow"

    actions = [
      "ec2:CreateSubnet"
    ]

    resources = [
      "arn:aws:ec2:*:*:subnet/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  statement {
    sid    = "CreateSubnetInOwnVPC"
    effect = "Allow"

    actions = [
      "ec2:CreateSubnet"
    ]

    resources = [
      "arn:aws:ec2:*:*:vpc/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  # Internet Gateway
  statement {
    sid    = "ManageInternetGateway"
    effect = "Allow"

    actions = [
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  # Route tables
  statement {
    sid    = "ManageRouteTables"
    effect = "Allow"

    actions = [
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:CreateRoute",
      "ec2:ReplaceRoute",
      "ec2:DeleteRoute",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  # Security Groups
  statement {
    sid    = "CreateSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:CreateSecurityGroup"
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  statement {
    sid    = "CreateSecurityGroupInOwnVPC"
    effect = "Allow"

    actions = [
      "ec2:CreateSecurityGroup"
    ]

    resources = [
      "arn:aws:ec2:*:*:vpc/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }
  statement {
    sid    = "ManageSecurityGroupRules"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress"
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  statement {
    sid    = "DeleteOwnSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:DeleteSecurityGroup"
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"
      values   = ["$${aws:PrincipalTag/Student}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      
      values = var.allowed_aws_regions
    }
  }

  # Suppression VPC/subnets appartenant au stagiaire
  statement {
    sid    = "DeleteOwnNetwork"
    effect = "Allow"

    actions = [
      "ec2:DeleteVpc",
      "ec2:DeleteSubnet"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  # Modification des attributs réseau
  statement {
    sid    = "ModifyOwnNetwork"
    effect = "Allow"

    actions = [
      "ec2:ModifyVpcAttribute",
      "ec2:ModifySubnetAttribute"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  # Tags réseau
  statement {
    sid    = "TagNetworkResources"
    effect = "Allow"

    actions = [
      "ec2:CreateTags"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }
}

resource "aws_iam_policy" "student_vpc" {
  name        = "tf-formation-student-vpc"
  description = "Permissions VPC pour les stagiaires Terraform"

  policy = data.aws_iam_policy_document.student_vpc.json
}

resource "aws_iam_user_policy_attachment" "students_vpc" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = aws_iam_policy.student_vpc.arn
}