resource "aws_iam_role_policy" "workstation_secrets" {
  count = var.create_workstation_secrets_policy ? 1 : 0

  name = "${local.name_prefix}-workstation-secrets-read"
  role = aws_iam_role.workstation.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = var.student_secret_arns
      }
    ]
  })
}