provider "aws" {
    region     = "ap-northeast-2"
}

data "terraform_remote_state" "s3" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="csv/s3.tfstate"
        encrypt = true
    }
}


terraform {
    required_providers{
        aws ={
            version = "~>4.10"
        }
    }
    backend "s3" {
        bucket = "s3-an2-lsj-dev-terraform"
        key ="csv/Network.tfstate"
        region = "ap-northeast-2"
        encrypt = true
    }
}