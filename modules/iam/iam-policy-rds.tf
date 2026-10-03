data "aws_iam_policy_document" "student_rds" {

  statement {
    sid    = "DescribeRDS"
    effect = "Allow"

    actions = [
      "rds:Describe*",
      "rds:ListTagsForResource"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateDBInstance"
    effect = "Allow"

    actions = [
      "rds:CreateDBInstance"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "rds:DatabaseEngine"

      values = [
        "mysql"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "rds:DatabaseClass"

      values = [
        "db.t3.micro"
      ]
    }
  }

  statement {
    sid    = "ManageOwnDB"
    effect = "Allow"

    actions = [
      "rds:ModifyDBInstance",
      "rds:RebootDBInstance",
      "rds:StartDBInstance",
      "rds:StopDBInstance",
      "rds:DeleteDBInstance"
    ]

    resources = [
      "arn:aws:rds:*:*:db:tf-formation-$${aws:PrincipalTag/Student}-*"
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
    sid    = "ManageOwnSubnetGroups"
    effect = "Allow"

    actions = [
      "rds:CreateDBSubnetGroup"
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

  statement {
    sid    = "DeleteOwnSubnetGroups"
    effect = "Allow"

    actions = [
      "rds:DeleteDBSubnetGroup"
    ]

    resources = [
      "arn:aws:rds:*:*:subgrp:tf-formation-$${aws:PrincipalTag/Student}-*"
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
    sid    = "TagRDSResources"
    effect = "Allow"

    actions = [
      "rds:AddTagsToResource"
    ]

    resources = [
      "arn:aws:rds:*:*:db:tf-formation-$${aws:PrincipalTag/Student}-*",
      "arn:aws:rds:*:*:subgrp:tf-formation-$${aws:PrincipalTag/Student}-*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }
}

resource "aws_iam_policy" "student_rds" {
  name        = "tf-formation-student-rds"
  description = "Permissions RDS pour les stagiaires Terraform"

  policy = data.aws_iam_policy_document.student_rds.json
}

resource "aws_iam_user_policy_attachment" "students_rds" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = aws_iam_policy.student_rds.arn
}