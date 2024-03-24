terraform {
    reguired_providers {
        aws = {
            version = "≥ 4.9.0"
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
  region = "us-west-2"
}
