data "aws_iam_policy_document" "student" {

  # ------------------------------------------------------------
  # 1. Changement du mot de passe
  # ------------------------------------------------------------
  statement {
    sid    = "ChangeOwnPassword"
    effect = "Allow"

    actions = [
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy"
    ]

    resources = ["*"]
  }
}


# ------------------------------------------------------------
# 2. Autoriser le changement de mot de passe
# ------------------------------------------------------------

resource "aws_iam_user_policy_attachment" "students_change_password" {
  for_each = local.students

  user       = aws_iam_user.students[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}




resource "aws_iam_user" "students" {
  for_each = local.students

  name = each.value

  tags = {
    Student = each.key
  }
}

resource "aws_iam_access_key" "students" {
  for_each = local.students

  user = aws_iam_user.students[each.key].name
}

resource "aws_iam_user_login_profile" "students" {
  for_each = local.students

  user                    = aws_iam_user.students[each.key].name
  password_length         = 20
  password_reset_required = true
}