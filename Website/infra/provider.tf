terraform {
    reguired_providers {
        aws = {
            version = "≥ 4.9.0"
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    profile = "your_cli_profile"
    access_key = "your_access_key"
    secret_access_key = "your_secret_access_key"
    region = "us-west-2"
}