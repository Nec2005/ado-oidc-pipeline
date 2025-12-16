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
  use_oidc = true
}

#