// Create terraform block to define terraform version, provider
terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "terraform-duc-backend"
    key    = "backends/state.tfstate"
    region = "ap-southeast-1"
  }
}

// Use the provider block to configure the AWS region to "ap-southest-1".
provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "another-region"
}

