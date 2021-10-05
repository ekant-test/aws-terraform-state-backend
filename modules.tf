module "shs" {
  source                  = "./modules/shs"
  common_tags             = local.common_tags
  cloud_id                = var.cloud_id
  master_account_id       = var.master_account_id
  state_bucket_versioning = var.state_bucket_versioning
  providers = {
    aws = aws.shs
  }
}
