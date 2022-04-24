output "vpc" {
    value = module.vpc.vpc
}

output "igw" {
    value = module.vpc.internet_gateway
}
