provider "aws" {
    region     = "ap-northeast-2"
}

terraform {
    required_providers{
        aws ={
            version = "~>4.10"
        }
    }

    backend "s3" {
        bucket = "s3-an2-lsj-dev-terraform"
        key ="csv/s3.tfstate"
        region = "ap-northeast-2"
        encrypt = true
    }
}
