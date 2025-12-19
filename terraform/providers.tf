terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }

  backend "s3" {
    encrypt        = true
    bucket         = "eu-west-1-chillipharm-terraform-state-necatidev"
    key            = "aws/ado-oidc-pipeline/terraform.tfstate"
    region         = "eu-west-1"
    use_lockfile   = true
  }
}

provider "aws" {
  region = var.aws_region
}

provider "azuredevops" {
  org_service_url = var.azuredevops_org_service_url
  # client_id            = "eea374a1-4536-49c5-b857-609555d7060b"
  # tenant_id            = "7fb00207-c2a9-42ba-b119-d3ed58581456"
  use_oidc = true
}
