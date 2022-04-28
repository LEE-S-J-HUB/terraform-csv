variable "vpcs"{
    type = list(object({
        identifier              = string
        vpc_cidr                = string
        attach_igw              = bool
        enable_dns_hostname     = bool
        name_tag_postfix        = string
    }))
}


variable "subnets" {
    type = list(object({
        identifier              = string
        vpc_identifier          = string 
        availability_zone       = string
        cidr_block              = string
        create_ngw              = bool
        name_tag_postfix        = string
    }))
}

variable "rts" {
    type = list(object({    
        rt_identifier           = string
        vpc_identifier          = string
        name_tag_postfix        = string
    }))
}

variable "rtps" {
    type = list(object({
        rt_identifier                   = string
        rtp_identifier                  = string 
        target_type                     = string 
        target_identifier               = string
        destination_type                = string
        destination_address             = string
        
    }))
}

variable "rtas" {
    type = list(object({
        rt_identifier = string
        association_subent_identifier = string
    }))
}


variable "name_tag_middle" {
    type                        = string
}