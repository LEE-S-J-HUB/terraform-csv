variable "vpc_data"{
    type = list(object({
        identifier              = string
        vpc_cidr                = string
        attach_igw              = bool
        enable_dns_hostname     = bool
        name_tag                = string
    }))
}