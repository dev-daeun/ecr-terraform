resource "aws_s3_bucket" "tfstate" {
  bucket = "devdaeun-terraform-state"
  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}
