resource "aws_s3_bucket" "buckets" {
  for_each      = var.buckets_name
  bucket        = each.value
  force_destroy = var.enable_force_destroy
  tags = {
    Name = each.value
  }
}
