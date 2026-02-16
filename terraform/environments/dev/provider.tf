terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket       = "birds-app-state-marian-2026"
  #   key          = "dev-new/terraform.tfstate"
  #   region       = "eu-central-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

