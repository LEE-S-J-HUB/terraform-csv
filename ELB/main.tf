locals {
    name_tag_middle         = "an2-tc01-dev"
}

resource "aws_lb" "this" {
    name = "xnlb-${local.name_tag_middle}"
    load_balancer_type = "network"
    internal           = false
    enable_deletion_protection = true
    subnets = [data.terraform_remote_state.Network.outputs.sub_id["pub-lb-a"], data.terraform_remote_state.Network.outputs.sub_id["pub-lb-c"]]
    tags = {
      "Name" = "xnlb-${local.name_tag_middle}"
    }
}