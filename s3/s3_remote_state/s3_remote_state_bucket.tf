provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "dadams-terraform_remote_state"
  acl = "authenticated-read"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "noncurrentexpire30"
    prefix = "/"
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }
}
