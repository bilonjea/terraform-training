resource "aws_iam_role" "vault" {
  name = "${local.name_prefix}-vault-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_instance_profile" "vault" {
  name = "${local.name_prefix}-vault-profile"
  role = aws_iam_role.vault.name
}