output "vpc" {
    value = module.vpc.vpc
}

output "igw" {
    value = module.vpc.internet_gateway
}

output "sub" {
    value = module.vpc.subnet
}

output "nat" {
    value = module.vpc.nat_gateway
}

