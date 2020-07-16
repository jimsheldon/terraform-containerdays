terraform {
  backend "s3" {
    bucket = "terraform-state-jimcontainerdays-demo"
    key    = "eu-west-1/default.tfstate"
    region = "eu-west-1"
  }
}

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}
