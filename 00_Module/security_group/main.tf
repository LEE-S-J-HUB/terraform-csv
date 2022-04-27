resource "aws_security_group" "security_group" {
    for_each            = { for sg in var.sgs : sg.identifier => sg }
    vpc_id              = var.vpc_id_list["${each.value.vpc_identifier}"]
    name                = "scg-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    tags                = {
        "Name" = "scg-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_security_group_rule" "security_group_rule_cidr_blocks" {
    for_each                    = { for sgp in var.security_group_rule_list : "${sgp.security_group_identifier}_${sgp.rule_type}_${sgp.from_port}_${sgp.from_port}_${sgp.cidr_block}" => sgp if sgp.source_type == "cidr_blocks"}
    type                        = each.value.rule_type
    security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
    from_port                   = each.value.from_port
    to_port                     = each.value.to_port
    protocol                    = each.value.protocol
    cidr_blocks                 = ["${each.value.cidr_block}"]
    ipv6_cidr_blocks            = null
    prefix_list_ids             = null
    description                 = each.value.description
}

resource "aws_security_group_rule" "security_group_rule_source_security_group_id" {
    for_each                    = { for sgp in var.security_group_rule_list : "${sgp.security_group_identifier}_${sgp.rule_type}_${sgp.from_port}_${sgp.from_port}_${sgp.source_security_group_id}" => sgp if sgp.source_type == "source_security_group_id"}
    type                        = each.value.rule_type
    security_group_id           = aws_security_group.security_group["${each.value.security_group_identifier}"].id
    from_port                   = each.value.from_port
    to_port                     = each.value.to_port
    protocol                    = each.value.protocol
    source_security_group_id    = "${each.value.source_security_group_id}"
    cidr_blocks                 = null
    prefix_list_ids             = null
    description                 = each.value.description
}