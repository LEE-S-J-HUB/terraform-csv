resource "aws_security_group" "security_group" {
    for_each            = { for sg in var.sgs : sg.identifier => sg }
    vpc_id              = var.vpc_id_list["${each.value.vpc_identifier}"]
    name                = "scg-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    tags                = {
        "Name" = "scg-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

# resource "aws_security_group_rule" "egress_with_cidr_blocks" {
#     type                        = "egress"
#     for_each                    = { for egress_cidr in var.egress_policy_list : egress_cidr.identifier => egress_cidr if egress_cidr.policy_type == "cidr_blocks"}
#     security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
#     from_port                   = lookuph.value, "from_port", null)
#     to_port                     = lookup(each.value, "to_port", null)
#     protocol                    = lookup(each.value, "protocol", null)
#     cidr_blocks                 = lookup(each.value, "cidr_blocks", null)
#     description                 = lookup(each.value, "description", null)
# }

# resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
#     type                        = "ingress"
#     for_each                    = { for ingress_cidr in var.ingress_policy_list : ingress_cidr.identifier => ingress_cidr if ingress_cidr.policy_type == "cidr_blocks"}
#     security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
#     from_port                   = lookup(each.value, "from_port", null)
#     to_port                     = lookup(each.value, "to_port", null)
#     protocol                    = lookup(each.value, "protocol", null)
#     cidr_blocks                 = lookup(each.value, "cidr_blocks", null)
#     description                 = lookup(each.value, "description", null)
# }

# resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
#     type                        = "ingress"
#     for_each                    = { for ingress_ssgi in var.ingress_policy_list : ingress_ssgi.identifier => ingress_ssgi if ingress_ssgi.policy_type == "source_security_group_id"}
#     security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
#     from_port                   = lookup(each.value, "from_port", null)
#     to_port                     = lookup(each.value, "to_port", null)
#     protocol                    = lookup(each.value, "protocol", null)
#     source_security_group_id    = aws_security_group.security_group["${each.value.source_security_group_id}"].id
#     description                 = lookup(each.value, "description", null)
# }

# resource "aws_security_group_rule" "egress_with_source_security_group_id" {
#     type                        = "egress"
#     for_each                    = { for egress_ssgi in var.egress_policy_list : egress_ssgi.identifier => egress_ssgi if egress_ssgi.policy_type == "source_security_group_id"}
#     security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
#     from_port                   = lookup(each.value, "from_port", null)
#     to_port                     = lookup(each.value, "to_port", null)
#     protocol                    = lookup(each.value, "protocol", null)
#     source_security_group_id    = aws_security_group.security_group["${each.value.source_security_group_id}"].id
#     description                 = lookup(each.value, "description", null)

# }