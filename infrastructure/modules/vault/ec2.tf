resource "aws_instance" "vault" {
  ami           = data.aws_ssm_parameter.ubuntu_2604.value
  instance_type = var.instance_type

  associate_public_ip_address = false

  iam_instance_profile = var.iam_instance_profile_name

  lifecycle {
    ignore_changes = [
      associate_public_ip_address
    ]
  }

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.vault.id
  ]

  user_data_base64 = base64gzip(
    templatefile(
      "${path.module}/templates/userdata.sh.tftpl",
      {
        formateur_public_key = var.formateur_public_key
        vault_token          = var.vault_token
      }
    )
  )

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "terraform-training-vault"
  }
}