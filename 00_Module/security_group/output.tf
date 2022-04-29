output "security_group" {
    value = aws_security_group.security_group
}

output "security_group_rule_cidr_blocks" {
    value = aws_security_group_rule.security_group_rule_cidr_blocks
}

output "security_group_rule_source_security_group_id" {
    value = aws_security_group_rule.security_group_rule_source_security_group_id
}