resource "aws_eip" "workstation" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-workstation"
  }
}

resource "aws_eip_association" "workstation" {
  instance_id   = aws_instance.workstation.id
  allocation_id = aws_eip.workstation.id
}