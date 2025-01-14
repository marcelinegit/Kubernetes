#Configuration options for AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "linda-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-linda"
  }
}
