resource "aws_s3_bucket" "terraform_state" {
  bucket = "birds-app-state-marian-2026"
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}