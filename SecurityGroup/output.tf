output "security_group" {
    value = { for k,sg in module.create-security_group.security_group : k => sg.id }
}

output "security_group_rule_cidr_blocks" {
    value = module.create-security_group.security_group_rule_cidr_blocks
}