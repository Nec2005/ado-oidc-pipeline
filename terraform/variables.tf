variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "Demo"
}

variable "buckets" {
  description = "Map of S3 buckets to create with their configurations"
  type = map(object({
    versioning_enabled = bool
    lifecycle_enabled  = bool
    purpose           = string
  }))
  default = {
    "app-data" = {
      versioning_enabled = true
      lifecycle_enabled  = true
      purpose           = "Application Data"
    }
    "logs" = {
      versioning_enabled = true
      lifecycle_enabled  = true
      purpose           = "Application Logs"
    }
    "backups" = {
      versioning_enabled = true
      lifecycle_enabled  = true
      purpose           = "Backup Storage"
    }
    "artifacts" = {
      versioning_enabled = false
      lifecycle_enabled  = true
      purpose           = "Build Artifacts"
    }
  }
}

variable "azuredevops_org_service_url" {
  description = "Azure DevOps organization URL"
  type        = string
  default     = "https://dev.azure.com/necdemo"
}