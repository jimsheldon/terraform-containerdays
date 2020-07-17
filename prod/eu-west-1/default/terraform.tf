terraform {
  backend "s3" {
    bucket = "terraform-state-jimcontainerdays-demoprod"
    key    = "eu-west-1/default.tfstate"
    region = "eu-west-1"

    // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/5018
    skip_metadata_api_check = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}
