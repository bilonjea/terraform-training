terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.66"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "5.12.0"
    }
  }
}