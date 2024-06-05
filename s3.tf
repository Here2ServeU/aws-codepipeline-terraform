# Creating a KMS key is not necessary for this lab. 
# Instead, we will use the default KMS key for S3 buckets.

resource "aws_s3_bucket" "codebuild-cache" {
  bucket = "t2s-codebuild-cache-${random_string.random.result}"
}

resource "aws_s3_bucket" "t2s-artifacts" {
  bucket = "t2s-artifacts-${random_string.random.result}"
  
  # lifecycle moved to aws_s3_bucket_lifecycle_configuration (Change starting from AWS Provider 4.x)
}

resource "aws_s3_bucket_lifecycle_configuration" "t2s-artifacts-lifecycle" {
  bucket = aws_s3_bucket.t2s-artifacts.id

  rule {
    id     = "clean-up"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}


resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

