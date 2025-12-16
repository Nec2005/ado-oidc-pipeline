
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = var.project_name
  }
}

# S3 Buckets
resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket = "demo-ado-necatidev-20251216}-${each.key}"

  tags = merge(
    local.common_tags,
    {
      Name    = "${var.project_name}-${each.key}"
      Purpose = each.value.purpose
    }
  )
}

# Enable versioning on buckets
resource "aws_s3_bucket_versioning" "this" {
  for_each = { for k, v in var.buckets : k => v if v.versioning_enabled }

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policies
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = { for k, v in var.buckets : k => v if v.lifecycle_enabled }

  bucket = aws_s3_bucket.this[each.key].id

  # Transition to Infrequent Access after 30 days
  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }

  # Clean up old versions
  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  # Clean up incomplete multipart uploads
  rule {
    id     = "abort-incomplete-multipart-upload"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Outputs
output "bucket_ids" {
  description = "Map of bucket names to their IDs"
  value       = { for k, bucket in aws_s3_bucket.this : k => bucket.id }
}

output "bucket_arns" {
  description = "Map of bucket names to their ARNs"
  value       = { for k, bucket in aws_s3_bucket.this : k => bucket.arn }
}

output "bucket_regional_domain_names" {
  description = "Map of bucket names to their regional domain names"
  value       = { for k, bucket in aws_s3_bucket.this : k => bucket.bucket_regional_domain_name }
}

output "bucket_details" {
  description = "Complete bucket details"
  value = {
    for k, bucket in aws_s3_bucket.this : k => {
      id          = bucket.id
      arn         = bucket.arn
      region      = bucket.region
      domain_name = bucket.bucket_regional_domain_name
    }
  }
}