resource "aws_eip" "vault" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-vault"
  }
}

resource "aws_eip_association" "vault" {
  instance_id   = aws_instance.vault.id
  allocation_id = aws_eip.vault.id
}