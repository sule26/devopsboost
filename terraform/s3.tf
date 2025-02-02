# resource "aws_s3_bucket" "bucket" {
#   bucket        = var.bucket_name
#   force_destroy = var.enable_force_destroy
#   tags = {
#     Name = var.bucket_name
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.bucket.id
#   versioning_configuration {
#     status = var.versioning
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "versioning_lifecycle" {
#   bucket = aws_s3_bucket.bucket.id
#   rule {
#     id     = "Keep only the latest ${var.stored_version} versions of a File"
#     status = var.versioning_lifecycle
#     noncurrent_version_expiration {
#       newer_noncurrent_versions = var.stored_version - 1
#       noncurrent_days           = 1
#     }
#   }
# }
