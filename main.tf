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

# Redshift
resource "aws_security_group" "aws_lab_redshift_sg" {
  name        = "aws_lab_redshift_sg"
  description = "Allow Redshift connections"
  vpc_id      = aws_vpc.aws_lab_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_redshift_sg"
    }
  )
}

resource "aws_redshiftserverless_namespace" "aws_lab_redshift_db" {
  namespace_name = "aws_lab"
  db_name        = "aws_lab"

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_redshift_db"
    }
  )
}


resource "aws_redshiftserverless_workgroup" "aws_lab_redshift_wg" {
  workgroup_name       = "aws_lab_redshift_wg"
  namespace_name       = aws_redshiftserverless_namespace.aws_lab_redshift_db.namespace_name
  base_capacity        = 8
  enhanced_vpc_routing = true

  security_group_ids = [aws_security_group.aws_lab_redshift_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_0.id,
    aws_subnet.private_subnet_1.id
  ]

  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_redshift_wg"
    }
  )
}
