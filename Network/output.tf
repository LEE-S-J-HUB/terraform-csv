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

output "route_table" {
    value = module.vpc.route_table
}