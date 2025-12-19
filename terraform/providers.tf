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
    assume_role = {
      role_arn = "arn:aws:iam::533267146698:role/ADODeploymentRole"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::533267146698:role/ADODeploymentRole"
  }
}

provider "azuredevops" {
  org_service_url = var.azuredevops_org_service_url
  # client_id            = "1a550dca-bd4e-4c4d-8916-845a818246a3"
  # tenant_id            = "7fb00207-c2a9-42ba-b119-d3ed58581456"
  use_oidc = true
}
