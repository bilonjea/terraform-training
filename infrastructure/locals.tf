locals {
  common_tags = {
    Formation = "terraform"
    ManagedBy = "terraform"
  }

  formateur_public_key = file(
    pathexpand("~/.ssh/id_ed25519.pub")
  )

  training_az = sort(
    data.aws_ec2_instance_type_offerings.training.locations
  )[0]
}
