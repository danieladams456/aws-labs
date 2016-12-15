provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "dadams-terraform_remote_state"
  acl = "authenticated-read"

  versioning {
    enabled = true
  }
}
