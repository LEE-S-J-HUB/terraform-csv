variable "name_tag_middle" {
    type        = string
}

variable "sgs" {
    type = list(object({
        identifier          = string
        vpc_identifier      = string
        name_tag_postfix    = string
    }))
}

variable "vpc_id_list" {
    type = map
}

variable "security_group_rule_list" {
    type    = list(object({
        security_group_identifier   = string
        rule_type                 = string
        source_type                 = string
        from_port                   = number
        to_port                     = number
        protocol                    = string
        cidr_block                  = string
        source_security_group_id    = string
        description                 = string
    }))
}