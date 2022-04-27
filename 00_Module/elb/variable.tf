variable "name_tag_middle" {
    type        = string
}

variable "elbs" {
    type = list(object({
        identifier                  = string
        name                        = string
        load_balancer_type          = string
        security_group              = list(string)
        internal                    = bool
        subnets                     = list(string)
        enable_deletion_protection  = bool               
    }))
}