locals {
    name_tag_middle         = "an2-tc01-dev"
    sgs_csv                 = file("./Resource/security_group.csv")
    sgrs_csv                 = file("./Resource/security_group_rule.csv")
}

module "create-security_group" {
    source          = "../00_Module/security_group"
    vpc_id_list     = data.terraform_remote_state.Network.outputs.vpc_id
    sgs                      = csvdecode(local.sgs_csv)
    security_group_rule_list = csvdecode(local.sgrs_csv)
    name_tag_middle          = local.name_tag_middle 
}