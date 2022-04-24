locals {
    vpc_csv     = file("./Resource/vpc.csv")
}

module "vpc" {
    source      = "./vpc/"
    vpc_data    = csvdecode(local.vpc_csv)
}