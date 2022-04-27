provider "aws" {
    region     = "ap-northeast-2"
}

terraform {
    backend "s3" {
        bucket = "s3-an2-lsj-dev-terraform"
        key ="csv/s3.tfstate"
        region = "ap-northeast-2"
        encrypt = true
    }
}