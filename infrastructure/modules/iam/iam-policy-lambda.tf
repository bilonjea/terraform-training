data "aws_iam_policy_document" "student_lambda" {

  statement {
    sid    = "DescribeLambda"
    effect = "Allow"

    actions = [
      "lambda:Get*",
      "lambda:List*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateLambdaFunction"
    effect = "Allow"

    actions = [
      "lambda:CreateFunction"
    ]

    resources = [
      "arn:aws:lambda:*:*:function:tf-formation-$${aws:PrincipalTag/Student}-*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  statement {
    sid    = "ManageOwnLambda"
    effect = "Allow"

    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:PublishVersion",
      "lambda:DeleteFunction",
      "lambda:InvokeFunction",
      "lambda:AddPermission",
      "lambda:RemovePermission"
    ]

    resources = [
      "arn:aws:lambda:*:*:function:tf-formation-$${aws:PrincipalTag/Student}-*"
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
    sid    = "ManageFunctionUrl"
    effect = "Allow"

    actions = [
      "lambda:CreateFunctionUrlConfig",
      "lambda:UpdateFunctionUrlConfig",
      "lambda:GetFunctionUrlConfig",
      "lambda:DeleteFunctionUrlConfig"
    ]

    resources = [
      "arn:aws:lambda:*:*:function:tf-formation-$${aws:PrincipalTag/Student}-*"
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
    sid    = "TagLambda"
    effect = "Allow"

    actions = [
      "lambda:TagResource",
      "lambda:UntagResource"
    ]

    resources = [
      "arn:aws:lambda:*:*:function:tf-formation-$${aws:PrincipalTag/Student}-*"
    ]
  }

  # Rôle IAM créé par le TP Lambda
  statement {
    sid    = "CreateLambdaExecutionRole"
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:TagRole",
      "iam:UntagRole"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Student"

      values = [
        "$${aws:PrincipalTag/Student}"
      ]
    }
  }

  # Autorise uniquement le passage des rôles Lambda du stagiaire
  statement {
    sid    = "PassOwnLambdaRole"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "lambda.amazonaws.com"
      ]
    }
  }

  statement {
    sid    = "ReadOwnLambdaRole"
    effect = "Allow"

    actions = [
      "iam:GetRole"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]
  }
  statement {
    sid    = "ListOwnLambdaRolePolicies"
    effect = "Allow"

    actions = [
      "iam:ListRolePolicies"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]
  }

  statement {
    sid    = "ListOwnLambdaAttachedPolicies"
    effect = "Allow"

    actions = [
      "iam:ListAttachedRolePolicies"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]
  }
  statement {
    sid    = "ListOwnLambdaRoleInstanceProfiles"
    effect = "Allow"

    actions = [
      "iam:ListInstanceProfilesForRole"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]
  }
  statement {
    sid    = "DeleteOwnLambdaExecutionRole"
    effect = "Allow"

    actions = [
      "iam:DeleteRole"
    ]

    resources = [
      "arn:aws:iam::*:role/tf-formation-$${aws:PrincipalTag/Student}-lambda-*"
    ]
  }

}

resource "aws_iam_policy" "student_lambda" {
  name        = "tf-formation-student-lambda"
  description = "Permissions Lambda pour les stagiaires Terraform"

  policy = data.aws_iam_policy_document.student_lambda.json
}

resource "aws_iam_user_policy_attachment" "students_lambda" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = aws_iam_policy.student_lambda.arn
}