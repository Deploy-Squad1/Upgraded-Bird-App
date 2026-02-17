terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    backend "s3" {
    bucket = "birds-app-state-marian-2026"
    key    = "iam/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
    region = "eu-central-1"
}