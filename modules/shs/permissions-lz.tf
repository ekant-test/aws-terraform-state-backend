# create the landing zone state manager role used by all CD/CI processes
resource "aws_iam_policy" "lz_terraform_state_manager" {
  name        = "LandingZoneTerraformStateManagerAccess"
  description = "This policy will allow the managment of landing zone terraform state in shared services."
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      # manage bucket access
      {
        "Sid" : "CheckBuckets",
        "Effect" : "Allow",
        "Action" : [
          "s3:HeadBucket"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ListStateBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : aws_s3_bucket.terraform_state.arn
      },
      {
        "Sid" : "ReadWriteCloudOpsStateFiles",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "${aws_s3_bucket.terraform_state.arn}/cloudops/core/*"
      },
      # allows the use of the state encryption key
      {
        "Sid" : "UseStateKey",
        "Effect" : "Allow",
        "Action" : [
          "kms:DescribeKey",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ],
        "Resource" : [
          "arn:aws:kms:*:${local.account_id}:key/${aws_kms_key.terraform_state.id}"
        ]
      },
      # allow the use of the state lock table
      {
        "Sid" : "UseStateLock",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : [
          "arn:aws:dynamodb:*:${local.account_id}:table/${aws_dynamodb_table.terraform_state_lock.name}"
        ]
      }
    ]
  })
}

# we delegate access to the s3 bucket to shared services AND master account managed by the cloudops team
resource "aws_iam_role" "lz_terraform_state_manager" {
  name = "LandingZoneTerraformStateManagerRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.master_account_id}:root"
          ]
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {}
      }
    ]
  })
}

# attach landing zone state manager policy to the trusting role
resource "aws_iam_role_policy_attachment" "lz_terraform_state_manager" {
  role       = aws_iam_role.lz_terraform_state_manager.name
  policy_arn = aws_iam_policy.lz_terraform_state_manager.arn
}
