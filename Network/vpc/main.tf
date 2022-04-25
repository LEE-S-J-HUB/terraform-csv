resource "aws_vpc" "this" {
    for_each                = { for vpc in var.vpc_data : vpc.identifier => vpc }
    cidr_block              = each.value.vpc_cidr
    enable_dns_hostnames    = each.value.enable_dns_hostname
    tags                    = {
        "Name" = "vpc-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_internet_gateway" "this" {
    for_each            = { for vpc in var.vpc_data : vpc.identifier => vpc if vpc.attach_igw == true  }
	vpc_id              = aws_vpc.this["${each.value.identifier}"].id
    tags                = {
        "Name" = "igw-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_subnet" "this" {
    for_each            = { for subnet in var.sub_data : subnet.identifier => subnet}
    vpc_id              = aws_vpc.this["${each.value.vpc_identifier}"].id
    availability_zone   = each.value.availability_zone
    cidr_block          = each.value.cidr_block
    tags                = {
        "Name" = "sub-${var.name_tag_middle}-${each.value.name_tag_postfix}"
    }
}

resource "aws_eip" "this" {
    for_each            = { for subnet in var.sub_data : subnet.identifier => subnet if subnet.create_ngw == true }
    vpc                 = true
    tags                = {
        "Name" = "eip-${var.name_tag_middle}-ngw"
    } 
}

resource "aws_nat_gateway" "this" {
    for_each            = { for subnet in var.sub_data : subnet.identifier => subnet if subnet.create_ngw == true }
    subnet_id           = aws_subnet.this["${each.value.identifier}"].id
    allocation_id       = aws_eip.this["${each.value.identifier}"].id
    tags                = {
        "Name" = "ngw-${var.name_tag_middle}"
    }
}