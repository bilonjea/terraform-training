data "aws_iam_policy_document" "student_s3" {

  statement {
    sid    = "ListBuckets"
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateOwnBucket"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:TagResource"
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
    sid    = "ManageOwnBucket"
    effect = "Allow"



    actions = [
      "s3:Get*",
      "s3:ListBucket",
      "s3:PutBucket*",
      "s3:DeleteBucket"
    ]

    resources = [
      "arn:aws:s3:::tf-formation-$${aws:PrincipalTag/Student}-s3-*"
    ]
  }

  statement {
    sid    = "ManageOwnObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::tf-formation-$${aws:PrincipalTag/Student}-s3-*/*"
    ]
  }
}

resource "aws_iam_policy" "student_s3" {
  name        = "tf-formation-student-s3"
  description = "Permissions S3 pour les stagiaires Terraform"

  policy = data.aws_iam_policy_document.student_s3.json
}

resource "aws_iam_user_policy_attachment" "students_s3" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = aws_iam_policy.student_s3.arn
}