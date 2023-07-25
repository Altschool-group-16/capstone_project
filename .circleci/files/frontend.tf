# Variables
variable "ID" {
  description = "Unique identifier."
  type        = string
}

# Resources
resource "aws_s3_bucket" "WebsiteBucket" {
  bucket = "udapeople-${var.ID}"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.WebsiteBucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
    }
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.WebsiteBucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.WebsiteBucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.WebsiteBucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "WebsiteBucketPolicy" {
  bucket = aws_s3_bucket.WebsiteBucket.id
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.WebsiteBucket.id}/*"
      }
    ]
  }
EOF
}

# Outputs
output "WebsiteURL" {
  value       = aws_s3_bucket.WebsiteBucket.website_endpoint
  description = "URL for website hosted on S3"
}