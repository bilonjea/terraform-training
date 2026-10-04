
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.common_tags
  }

}

provider "vault" {
  address = var.vault_address
}