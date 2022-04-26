locals {
    name_tag_middle     = "an2-tc01-dev"
    vpc_csv             = file("./Resource/vpc.csv")
    sub_csv             = file("./Resource/subnet.csv")
    rt_csv              = file("./Resource/route_table.csv")
    rtp_csv             = file("./Resource/route_table_policy.csv")
}

module "vpc" {
    source              = "./vpc/"
    vpc_data            = csvdecode(local.vpc_csv)
    sub_data            = csvdecode(local.sub_csv)
    rt_data             = csvdecode(local.rt_csv)
    rtp_data            = csvdecode(local.rtp_csv)
    rta_data            = [
        {
            rt_identifier                   = "pub-lb"
            association_subent_identifier   = "pub-lb-a"
        },
        {
            rt_identifier                   = "pub-lb"
            association_subent_identifier   = "pub-lb-c"
        },
        {
            rt_identifier                   = "pub-web"
            association_subent_identifier   = "pub-web-a"
        },
        {
            rt_identifier                   = "pub-web"
            association_subent_identifier   = "pub-web-c"
        }
    ]
    name_tag_middle     = local.name_tag_middle
}