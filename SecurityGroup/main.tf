locals {
    name_tag_middle         = "an2-tc01-dev"
    sgs_csv                 = file("./Resource/security_group.csv")
}

module "create-security_group" {
    source          = "./security_group"
    vpc_id_list     = data.terraform_remote_state.Network.outputs.vpc_id
    sgs = csvdecode(local.sgs_csv)
    name_tag_middle     = local.name_tag_middle
}
#   policy_type : aws_security_group_rule 구분을 위한 필수 항목
#   cidr_blocks
#   source_security_group_id
