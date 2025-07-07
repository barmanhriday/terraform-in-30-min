resource "aws_s3_bucket" "only_ref_name" { # resource 
# declaration 
  bucket = "my-noida-bucket" #name of the bucket
  #there is no variable at all 
  #we create a simple bucket  with ACL parameters
 }
resource "aws_s3_bucket_public_access_block" "ref_name" { #ACL
  bucket = aws_s3_bucket.only_ref_name.id

  block_public_acls       = true # access block
  block_public_policy     = true # access block
  ignore_public_acls      = true # access block
  restrict_public_buckets = true # access block
}
