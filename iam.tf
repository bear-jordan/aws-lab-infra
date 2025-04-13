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
