provider "aws" {
    region     = "ap-northeast-2"
}

data "terraform_remote_state" "Network" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="csv/Network.tfstate"
        encrypt = true
    }
}

data "terraform_remote_state" "Security_Group" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="csv/Security_Group.tfstate"
        encrypt = true
    }
}

terraform {
    backend "s3" {
        bucket = "s3-an2-lsj-dev-terraform"
        key ="csv/Compute.tfstate"
        region = "ap-northeast-2"
        encrypt = true
    }
}