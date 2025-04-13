# Backend
terraform {
  backend "s3" {}
}

# S3
resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_s3_bucket" "aws_lab_bucket" {
  bucket = "aws-lab-bucket-${random_string.bucket_suffix.result}"

  tags = merge(
    var.default_tags,
    {
      Name = "aws-lab-bucket-${random_string.bucket_suffix.result}"
    }
  )
}

resource "aws_s3_bucket_acl" "aws_lab_bucket_acl" {
  bucket = aws_s3_bucket.aws_lab_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "aws_lab_bucket_versioning" {
  bucket = aws_s3_bucket.aws_lab_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "aws_lab_bucket_lifecycle" {
  bucket = aws_s3_bucket.aws_lab_bucket.id

  rule {
    id = "keep_current"
    filter {
      prefix = ""
    }
    noncurrent_version_expiration {
      noncurrent_days           = 3
      newer_noncurrent_versions = 1
    }
    status = "Enabled"
  }
}
