aws_region     = "us-east-1"
instance_type  = "m7i-flex.large" ## c7i-flex.large m7i-flex.large
student_count  = 10
aws_account_id = "557170680994"
session_id     = "TFVPA1-2026-10-04"
allowed_aws_regions = [
  "eu-west-3",
  "eu-west-2",
  "eu-west-1",
  "eu-central-1"
]
git_repositories = [
  "https://github.com/bilonjea/terraform-formation-template.git"
]
create_workstation     = true
enable_secrets_manager = true
credentials_mode       = "vault" # secrets_manager | vault | local
vault_dev_root_token   = "training-root-token"