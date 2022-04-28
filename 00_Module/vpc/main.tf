resource "aws_vpc" "this" {
    for_each                = { for vpc in var.vpcs : vpc.identifier => vpc }
    cidr_block              = each.value.vpc_cidr
    enable_dns_hostnames    = each.value.enable_dns_hostname
    tags                    = {
        "Name" = "vpc-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_internet_gateway" "this" {
    for_each            = { for vpc in var.vpcs : vpc.identifier => vpc if vpc.attach_igw == true  }
	vpc_id              = aws_vpc.this["${each.value.identifier}"].id
    tags                = {
        "Name" = "igw-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_subnet" "this" {
    for_each            = { for subnet in var.subnets : subnet.identifier => subnet}
    vpc_id              = aws_vpc.this["${each.value.vpc_identifier}"].id
    availability_zone   = each.value.availability_zone
    cidr_block          = each.value.cidr_block
    tags                = {
        "Name" = "sub-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_eip" "this" {
    for_each            = { for subnet in var.subnets : subnet.identifier => subnet if subnet.create_ngw == true }
    vpc                 = true
    tags                = {
        "Name" = "eip-${var.name_tag_middle}-ngw"
    } 
}

resource "aws_nat_gateway" "this" {
    for_each            = { for subnet in var.subnets : subnet.identifier => subnet if subnet.create_ngw == true }
    subnet_id           = aws_subnet.this["${each.value.identifier}"].id
    allocation_id       = aws_eip.this["${each.value.identifier}"].id
    tags                = {
        "Name" = "ngw-${var.name_tag_middle}"
    }
}

resource "aws_route_table" "this" {
    for_each            = { for rt in var.rts : rt.rt_identifier => rt}
    vpc_id = aws_vpc.this["${each.value.vpc_identifier}"].id
    tags                = {
        "Name" = "rt-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_route_table_association" "this" {
    for_each        = { for rta in var.rtas : rta.association_subent_identifier => rta }
    route_table_id  = aws_route_table.this["${each.value.rt_identifier}"].id
    subnet_id   = aws_subnet.this["${each.value.association_subent_identifier}"].id
}

# aws_route type cidr_block
resource "aws_route" "carrier_gateway_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "carrier_gateway" && rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    carrier_gateway_id          = lookup(each.value, "carrier_gateway_id")
}

resource "aws_route" "core_network_arn_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "core_network_arn" && rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    core_network_arn            = lookup(each.value, "core_network_arn")
}

resource "aws_route" "egress_only_gateway_id_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "egress_only_gateway_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    egress_only_gateway_id      = lookup(each.value, "egress_only_gateway_id")
}

resource "aws_route" "gateway_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "gateway_id" && rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    gateway_id                  = aws_internet_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "instance_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "instance_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    instance_id                 = lookup(each.value, "instance_id")
}

resource "aws_route" "nat_gateway_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "nat_gateway_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    nat_gateway_id              = aws_nat_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "local_gateway_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "local_gateway_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    local_gateway_id            = lookup(each.value, "local_gateway_id")
}

resource "aws_route" "network_interface_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "network_interface_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    network_interface_id        = lookup(each.value, "network_interface_id")
}

resource "aws_route" "transit_gateway_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "transit_gateway_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    transit_gateway_id          = lookup(each.value, "transit_gateway_id")
}

resource "aws_route" "vpc_endpoint_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_endpoint_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_endpoint_id             = lookup(each.value, "vpc_endpoint_id")
}

resource "aws_route" "vpc_peering_connection_id_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_peering_connection_id"&& rtp.destination_type == "cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_peering_connection_id   = lookup(each.value, "vpc_peering_connection_id")
}


# aws_route type ipv6_cidr_block
resource "aws_route" "carrier_gateway_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "carrier_gateway" && rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    carrier_gateway_id          = lookup(each.value, "carrier_gateway_id")
}

resource "aws_route" "core_network_arn_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "core_network_arn" && rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    core_network_arn            = lookup(each.value, "core_network_arn")
}

resource "aws_route" "egress_only_gateway_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "egress_only_gateway_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    egress_only_gateway_id      = lookup(each.value, "egress_only_gateway_id")
}

resource "aws_route" "gateway_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "gateway_id" && rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    gateway_id                  = aws_internet_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "instance_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "instance_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    instance_id                 = lookup(each.value, "instance_id")
}

resource "aws_route" "nat_gateway_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "nat_gateway_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    nat_gateway_id              = aws_nat_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "local_gateway_id-ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "local_gateway_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    local_gateway_id            = lookup(each.value, "local_gateway_id")
}

resource "aws_route" "network_interface_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "network_interface_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    network_interface_id        = lookup(each.value, "network_interface_id")
}

resource "aws_route" "transit_gateway_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "transit_gateway_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    transit_gateway_id          = lookup(each.value, "transit_gateway_id")
}

resource "aws_route" "vpc_endpoint_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_endpoint_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_endpoint_id             = lookup(each.value, "vpc_endpoint_id")
}

resource "aws_route" "vpc_peering_connection_id_ipv6_cidr_block" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_peering_connection_id"&& rtp.destination_type == "ipv6_cidr_block"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_peering_connection_id   = lookup(each.value, "vpc_peering_connection_id")
}

# aws_route type prefix_list
resource "aws_route" "carrier_gateway" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "carrier_gateway" && rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    carrier_gateway_id          = lookup(each.value, "carrier_gateway_id")
}

resource "aws_route" "core_network_arn_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "core_network_arn" && rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    core_network_arn            = lookup(each.value, "core_network_arn")
}

resource "aws_route" "egress_only_gateway_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "egress_only_gateway_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    egress_only_gateway_id      = lookup(each.value, "egress_only_gateway_id")
}

resource "aws_route" "gateway_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "gateway_id" && rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    gateway_id                  = aws_internet_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "instance_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "instance_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    instance_id                 = lookup(each.value, "instance_id")
}

resource "aws_route" "nat_gateway_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "nat_gateway_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    nat_gateway_id              = aws_nat_gateway.this["${each.value.target_identifier}"].id
}

resource "aws_route" "local_gateway_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "local_gateway_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    local_gateway_id            = lookup(each.value, "local_gateway_id")
}

resource "aws_route" "network_interface_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "network_interface_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    network_interface_id        = lookup(each.value, "network_interface_id")
}

resource "aws_route" "transit_gateway_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "transit_gateway_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    transit_gateway_id          = lookup(each.value, "transit_gateway_id")
}

resource "aws_route" "vpc_endpoint_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_endpoint_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_endpoint_id             = lookup(each.value, "vpc_endpoint_id")
}

resource "aws_route" "vpc_peering_connection_id_prefix_list_id" {
    for_each                    = { for rtp in var.rtps : rtp.rt_identifier => rtp if rtp.target_type == "vpc_peering_connection_id"&& rtp.destination_type == "prefix_list_id"}
    route_table_id              = aws_route_table.this[each.value.rt_identifier].id
    destination_cidr_block      = lookup(each.value, "destination_address", null)
    vpc_peering_connection_id   = lookup(each.value, "vpc_peering_connection_id")
}