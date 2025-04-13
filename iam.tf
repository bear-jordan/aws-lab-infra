resource "aws_iam_user_policy_attachment" "query_editor_access" {
  user       = "bear"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2FullAccess"
}

resource "aws_iam_role" "vmimport" {
  name = "vmimport"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vmie.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" : "vmimport"
          }
        }
      }
    ]
  })

  tags = merge(
    var.default_tags,
    {
      Name = "vmimport"
    }
  )
}

resource "aws_iam_role_policy" "vmimport_policy" {
  name = "vmimport-permissions"
  role = aws_iam_role.vmimport.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::aws-lab-bucket-${random_string.bucket_suffix.result}",
          "arn:aws:s3:::aws-lab-bucket-${random_string.bucket_suffix.result}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:ModifySnapshotAttribute",
          "ec2:CopySnapshot",
          "ec2:RegisterImage",
          "ec2:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "vmimport_key" {
  description             = "KMS key for imported snapshots"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow vmimport to decrypt snapshots",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::216363851037:role/vmimport"
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })
}
