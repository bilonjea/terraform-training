resource "aws_instance" "workstation" {
  ami           = data.aws_ssm_parameter.ubuntu_2604.value
  instance_type = var.instance_type

  associate_public_ip_address = false

  iam_instance_profile = var.iam_instance_profile_name

  lifecycle {
    ignore_changes = [
      associate_public_ip_address
    ]

    replace_triggered_by = [
      terraform_data.workstation_config
    ]
  }

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.workstation.id
  ]

  user_data_base64 = base64gzip(templatefile(
    "${path.module}/templates/userdata.sh.tftpl",
    {
      students              = local.students
      student_password_b64  = local.student_password_b64
      formateur_public_key  = var.formateur_public_key
      workstation_public_ip = aws_eip.workstation.public_ip
      student_credentials   = local.student_credentials
      git_repositories      = var.git_repositories
      aws_account_id        = var.aws_account_id
      allowed_aws_regions   = var.allowed_aws_regions
      aws_region            = var.aws_region
      credentials_mode      = var.credentials_mode
      vault_private_ip      = var.vault_private_ip
      session_id            = var.session_id
    }
  ))

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "${local.name_prefix}-workstation"
  }
}
