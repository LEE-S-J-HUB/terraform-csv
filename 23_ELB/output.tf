output "alb_id" {
    value = {for k,elb in module.elb.alb : k => elb.id }
}


output "nlb_id" {
    value = {for k,elb in module.elb.nlb : k => elb.id }
}