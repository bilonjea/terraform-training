resource "aws_security_group" "vault" {
  name        = "${local.name_prefix}-vault"
  description = "Security group for Terraform training Vault"
  vpc_id      = var.vpc_id


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Vault API - administration"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "Vault API from training VPC"
  #   from_port   = 8200
  #   to_port     = 8200
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.20.0.0/16"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}