terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26"
    }
  }

  backend "s3" {
    bucket  = "faceworld-bucket-ynov"
    key     = "KEY"
    region  = "eu-west-3"
    profile = "facworldinfra"
  }
}

provider "aws" {
  region  = "eu-west-3"
  profile = "facworldinfra"
}