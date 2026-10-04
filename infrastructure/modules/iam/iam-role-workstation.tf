resource "aws_iam_role" "workstation" {
  name = "${local.name_prefix}-workstation-role"

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


resource "aws_iam_instance_profile" "workstation" {
  name = "${local.name_prefix}-workstation-profile"
  role = aws_iam_role.workstation.name
}