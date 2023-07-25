# Variables
variable "WorkflowID" {
  description = "Unique identifier."
  type        = string
}

# Resources
resource "aws_cloudfront_origin_access_identity" "CloudFrontOriginAccessIdentity" {
  comment = "Origin Access Identity for Serverless Static Website"
}

resource "aws_cloudfront_distribution" "WebpageCDN" {
  depends_on = [aws_cloudfront_origin_access_identity.CloudFrontOriginAccessIdentity]

  distribution_config {
    enabled             = true
    default_root_object = "index.html"

    origin {
      domain_name = "udapeople-${var.WorkflowID}.s3.amazonaws.com"
      origin_id   = "webpage"

      s3_origin_config {
        origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.CloudFrontOriginAccessIdentity.id}"
      }
    }

    default_cache_behavior {
      forwarded_values {
        query_string = false
      }
      target_origin_id     = "webpage"
      viewer_protocol_policy = "allow-all"
    }
  }
}

# Outputs
output "WorkflowID" {
  value       = var.WorkflowID
  description = "URL for website hosted on S3"
}