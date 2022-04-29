resource "aws_flow_log" "this" {
    for_each = {for vpc_flow_log in var.vpc_flow_logs : "${vpc_flow_log.vpc_id}_${vpc_flow_log.log_destination_type}" => vpc_flow_log }
    vpc_id                      = each.value.vpc_id
    log_destination             = each.value.log_destination
    log_destination_type        = each.value.log_destination_type
    traffic_type                = each.value.traffic_type    
    max_aggregation_interval    = each.value.max_aggregation_interval
}