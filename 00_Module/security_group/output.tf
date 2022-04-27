output "security_group" {
    value = aws_security_group.security_group
}

output "security_group_rule_cidr_blocks" {
    value = aws_security_group_rule.security_group_rule_cidr_blocks
}
# output "ingress_list" {
#     value = aws_security_group_rule.ingress_with_cidr_blocks
# }

# output "egress_list" {
#     value = aws_security_group_rule.egress_with_cidr_blocks
# }