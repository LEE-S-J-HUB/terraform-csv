resource "aws_lb" "alb" {
    for_each                        = { for elb in var.elbs : elb.identifier => elb if elb.load_balancer_type == "application"}
    name                            = each.value.name
    load_balancer_type              = each.value.load_balancer_type
    security_groups                 = each.value.security_group
    internal                        = each.value.internal
    enable_deletion_protection      = each.value.enable_deletion_protection
    subnets                         = each.value.subnets
    tags = {
      "Name" = "xalb-${var.name_tag_middle}"
    }
}

resource "aws_lb" "nlb" {
    for_each                        = { for elb in var.elbs : elb.identifier => elb if elb.load_balancer_type == "network"}
    name                            = each.value.name
    load_balancer_type              = each.value.load_balancer_type
    internal                        = each.value.internal
    enable_deletion_protection      = each.value.enable_deletion_protection
    subnets                         = each.value.subnets
    tags = {
      "Name" = "xalb-${var.name_tag_middle}"
    }
}