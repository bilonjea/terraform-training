data "aws_iam_policy_document" "student_ec2" {

  # ------------------------------------------------------------
  # 1. Lecture EC2
  # ------------------------------------------------------------
  #
  # Les Describe* ne supportent pas les permissions
  # au niveau d'une ressource EC2 précise.
  #
  statement {
    sid    = "DescribeEC2"
    effect = "Allow"

    actions = [
      "ec2:Describe*"
    ]

    resources = ["*"]
  }

  # ------------------------------------------------------------
  # 2. Créer une instance
  # ------------------------------------------------------------
  statement {
    sid    = "RunInstances"
    effect = "Allow"

    actions = [
      "ec2:RunInstances"
    ]

    resources = [
      "arn:aws:ec2:*:*:image/*",
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ec2:*:*:network-interface/*",
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:subnet/*",
      "arn:aws:ec2:*:*:security-group/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"

      values = var.allowed_aws_regions
    }
  }

  # ------------------------------------------------------------
  # 3. Autoriser le tagging lors du RunInstances
  # ------------------------------------------------------------
  statement {
    sid    = "TagOnRunInstances"
    effect = "Allow"

    actions = [
      "ec2:CreateTags"
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "RunInstances"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  # ------------------------------------------------------------
  # 4. Gestion des instances appartenant au stagiaire
  # ------------------------------------------------------------
  statement {
    sid    = "ManageOwnInstances"
    effect = "Allow"

    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:TerminateInstances"
    ]

    resources = [
      "arn:aws:ec2:*:*:instance/*"
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
}


# ------------------------------------------------------------
# Policy IAM
# ------------------------------------------------------------

resource "aws_iam_policy" "student_ec2" {
  name        = "tf-formation-student-ec2"
  description = "Permissions EC2 pour les stagiaires Terraform"

  policy = data.aws_iam_policy_document.student_ec2.json
}


# ------------------------------------------------------------
# Attachement aux utilisateurs
# ------------------------------------------------------------

resource "aws_iam_user_policy_attachment" "student_ec2" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = aws_iam_policy.student_ec2.arn
}


