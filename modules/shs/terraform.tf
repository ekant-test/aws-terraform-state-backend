# installs the terraform state bucket and associated backend components

# KMS key used for encryption of terraform state in the s3 bucket server side
resource "aws_kms_key" "terraform_state" {
  description             = "This key is used to encrypt the terraform state objects at rest"
  deletion_window_in_days = 14
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "iam-key-mgmt",
    "Statement" : [
      {
        "Sid" : "DelegateKeyManagementToIAM",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${local.account_id}:root"
          ]
        },
        "Action" : "kms:*",
        "Resource" : "*"
      }
    ]
  })
  tags = merge(
    map(
      "Name", "terraform-state-key",
    ),
    var.common_tags
  )
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/terraform-state-key"
  target_key_id = aws_kms_key.terraform_state.key_id
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${var.cloud_id}"
  acl    = "private"
  versioning {
    enabled = var.state_bucket_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_state.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    map(
      "Name", "terraform-state-${var.cloud_id}",
    ),
    var.common_tags
  )
}

# ensure to block all public access to the terraform state bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  restrict_public_buckets = true
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
}

# dynamodb locking table when applying terraform state during provisioning
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    map(
      "Name", "terraform-state-lock",
    ),
    var.common_tags
  )
}
