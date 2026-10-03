module "iam" {
  source = "./modules/iam"

  student_count       = var.student_count
  allowed_aws_regions = var.allowed_aws_regions
}


module "workstation" {
  count = var.create_workstation ? 1 : 0

  source = "./modules/workstation"

  instance_type       = var.instance_type
  student_count       = var.student_count
  student_credentials = module.iam.student_aws_credentials
  git_repositories    = var.git_repositories
  aws_account_id      = var.aws_account_id
  allowed_aws_regions = var.allowed_aws_regions

}