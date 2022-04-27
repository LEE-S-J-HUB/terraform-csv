locals {
    name_tag_middle         = "an2-tc01-dev"
}

module "elb" {
  source  = "../00_Module/elb/"
  elbs    = [
    {
      identifier                  = "xalb-${local.name_tag_middle}-web"
      name                        = "xalb-${local.name_tag_middle}-web"
      load_balancer_type          = "application"
      security_group              = ["${data.terraform_remote_state.Security_Group.outputs.security_group_id["xalb"]}"]
      internal                    = false
      subnets                     = ["${data.terraform_remote_state.Network.outputs.sub_id["pub-lb-a"]}", "${data.terraform_remote_state.Network.outputs.sub_id["pub-lb-c"]}"]
      enable_deletion_protection  = false
    }
  ]
  name_tag_middle         = local.name_tag_middle
}