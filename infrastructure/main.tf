module "secrets_manager" {
  count = var.enable_secrets_manager ? 1 : 0

  source = "./modules/secrets-manager"

  student_count       = var.student_count
  session_id          = var.session_id
  student_credentials = module.iam.student_aws_credentials
}

module "iam" {
  source = "./modules/iam"

  credentials_mode    = var.credentials_mode
  student_count       = var.student_count
  allowed_aws_regions = var.allowed_aws_regions

  create_workstation_secrets_policy = (
    var.credentials_mode == "secrets_manager"
  )

  student_secret_arns = try(
    module.secrets_manager[0].student_secret_arns,
    []
  )
}

module "network" {
  source = "./modules/network"

  availability_zone = local.training_az
}


module "workstation" {
  count = var.create_workstation ? 1 : 0

  source = "./modules/workstation"

  aws_region    = var.aws_region
  instance_type = var.instance_type
  student_count = var.student_count
  session_id    = var.session_id

  # utilisé uniquement en mode local
  student_credentials = module.iam.student_aws_credentials

  # utilisé en mode secrets_manager
  # secrets_manager_config = module.secrets_manager[...]

  # utilisé en mode vault
  # vault_config = module.vault[...]

  git_repositories    = var.git_repositories
  aws_account_id      = var.aws_account_id
  allowed_aws_regions = var.allowed_aws_regions

  iam_instance_profile_name = module.iam.workstation_instance_profile_name
  credentials_mode          = var.credentials_mode

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.subnet_id

  formateur_public_key = local.formateur_public_key

  vault_private_ip = module.vault.vault_private_ip

  depends_on = [
    module.iam,
    module.secrets_manager,
    module.vault
  ]

}

module "vault" {
  source = "./modules/vault"

  aws_region    = var.aws_region
  instance_type = "t3.micro"
  student_count = var.student_count

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.subnet_id

  formateur_public_key      = local.formateur_public_key
  iam_instance_profile_name = module.iam.vault_instance_profile_name

  vault_token = var.vault_dev_root_token
}


