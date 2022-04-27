provider "aws" {
    region     = "ap-northeast-2"
}


terraform {
    required_providers{
        aws ={
            source = "hashicorp/aws"
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