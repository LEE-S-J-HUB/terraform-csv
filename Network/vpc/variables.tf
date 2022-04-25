variable "vpc_data"{
    type = list(object({
        identifier              = string
        vpc_cidr                = string
        attach_igw              = bool
        enable_dns_hostname     = bool
        name_tag_postfix        = string
    }))
}


variable "sub_data" {
    type = list(object({
        identifier              = string
        vpc_identifier          = string 
        availability_zone       = string
        cidr_block              = string
        create_ngw              = bool
        name_tag_postfix        = string
    }))
}

variable "name_tag_middle" {
    type                        = string
}