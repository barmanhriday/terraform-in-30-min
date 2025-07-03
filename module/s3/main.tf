resource "aws_s3_bucket" "only_ref_name" {
  bucket = "my-noida-bucket"
 }
resource "aws_s3_bucket_public_access_block" "ref_name" {
  bucket = aws_s3_bucket.only_ref_name.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
