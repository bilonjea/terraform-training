resource "aws_iam_role_policy" "vault_aws_auth" {
  name = "${local.name_prefix}-vault-aws-auth"
  role = aws_iam_role.vault.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "iam:GetInstanceProfile",
          "iam:GetUser",
          "iam:GetRole"
        ]

        Resource = "*"
      }
    ]
  })
}