output "vpc_id" {
    value = { for k,vpc in module.vpc.vpc : k => vpc.id }
}

output "igw" {
    value = { for k,igw in module.vpc.internet_gateway : k =>igw.id }
}

output "sub" {
    value = { for k,sub in module.vpc.subnet : k => sub.id }
}

output "nat" {
    value = { for k,nat in module.vpc.nat_gateway : k => nat.id }
}

output "route_table" {
    value = { for k,rt in module.vpc.route_table : k => rt.id }
}