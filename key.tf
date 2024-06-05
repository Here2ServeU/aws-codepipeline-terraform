#
# kms
#
data "aws_iam_policy_document" "t2s-artifacts-kms-policy" {
  policy_id = "key-default-1"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_caller_identity" "current" {}


resource "aws_kms_key" "t2s-artifacts" {
  description = "Creating a KMS key for T2S artifacts"
  policy      = data.aws_iam_policy_document.t2s-artifacts-kms-policy.json
}

resource "aws_kms_alias" "t2s-artifacts" {
  name          = "alias/t2s-artifacts"
  target_key_id = aws_kms_key.t2s-artifacts.key_id
}


