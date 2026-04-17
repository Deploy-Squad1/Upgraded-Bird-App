terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
  backend "s3" {
    bucket = "birds-app-state-stage-2026"
    key    = "dev/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    use_lockfile = true
  }
}
provider "aws" {
    region = "eu-north-1"
}
