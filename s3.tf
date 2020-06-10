module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3-backup-config.bucket_name
  acl    = "private"

  versioning = {
    enabled = true
  }
  tags = {
    Terraform   = local.common-tags.Terraform
    Environment = local.common-tags.Environment
    Owner       = local.common-tags.Owner
  }
}
