output "security_group" {
    value = aws_security_group.security_group
}

# output "ingress_list" {
#     value = aws_security_group_rule.ingress_with_cidr_blocks
# }

# output "egress_list" {
#     value = aws_security_group_rule.egress_with_cidr_blocks
# }