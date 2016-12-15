resource "aws_s3_bucket" "public" {
  bucket = "dadams-public"
  acl = "public-read"
}
