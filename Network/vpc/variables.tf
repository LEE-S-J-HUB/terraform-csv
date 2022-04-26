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

variable "rt_data" {
    type = list(object({    
        rt_identifier           = string
        vpc_identifier          = string
        name_tag_postfix        = string
    }))
}

variable "rtp_data" {
    type = list(object({
        rt_identifier                   = string
        rtp_identifier                  = string 
        target_type                     = string 
        target_identifier               = string
        destination_type                = string
        destination_address             = string
        
    }))
}

variable "rta_data" {
    type = list(object({
        rt_identifier = string
        association_subent_identifier = string
    }))
}


variable "name_tag_middle" {
    type                        = string
}