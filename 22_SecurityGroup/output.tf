output "security_group_id" {
    value = { for k,sg in module.create-security_group.security_group : k => sg.id }
}

output "security_group_rule_cidr_blocks" {
    value = { for k,sgp in module.create-security_group.security_group_rule_cidr_blocks : k => sgp.id if sgp.cidr_blocks != null}
}

output "security_group_rule_source_security_group_id" {
    value = { for k,sgp in module.create-security_group.security_group_rule_source_security_group_id : k => sgp.id if sgp.cidr_blocks != null}
}