provider "aws" {
  region = "us-east-2"
  profile = "default"
}

terraform {
  experiments = [variable_validation]
}