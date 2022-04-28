variable "name_tag_middle" {
    type                        = string
}

variable "vpc_flow_logs" {
    type = list(object({
        vpc_id                      = string
        log_destination             = string
        log_destination_type        = string
        traffic_type                = string
        max_aggregation_interval    = string
    }))
}