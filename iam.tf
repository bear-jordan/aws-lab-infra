resource "aws_iam_user_policy_attachment" "query_editor_access" {
  user       = "bear"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftQueryEditorV2FullAccess"
}

resource "aws_kms_key" "vmimport_key" {
  description             = "KMS key for vmimport"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow vmimport to decrypt SSE-KMS key",
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::216363851037:role/vmimport"
          ]
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
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
