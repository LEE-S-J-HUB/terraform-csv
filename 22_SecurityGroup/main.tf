locals {
    name_tag_middle         = "an2-tc01-dev"
    sgrs_csv                 = file("./Resource/security_group_rule.csv")
}

module "create-security_group" {
    source          = "../00_Module/security_group"
    vpc_id_list     = data.terraform_remote_state.Network.outputs.vpc_id
    sgs             = [
        {
            identifier       = "bestion"
            vpc_identifier   = "public"
            name_tag_postfix = "bestion"
        },
        {
            identifier       = "web"
            vpc_identifier   = "public"
            name_tag_postfix = "web"
        },
        {
            identifier       = "xalb"
            vpc_identifier   = "public"
            name_tag_postfix = "xalb"
        }
    ]
    security_group_rule_list = csvdecode(local.sgrs_csv)
    name_tag_middle          = local.name_tag_middle 
}
# SecurityGroup rule object key 
# cidr_block : "{Security_group_identifier}_{rule_type}_{from_port}_{to_port}_{cidr_block}"
# source_security_group_id : "{Security_group_identifier}_{rule_type}_{from_port}_{to_port}_{source_security_group_id}"
