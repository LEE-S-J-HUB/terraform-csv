locals {
    name_tag_middle     = "an2-tc01-dev"
}

module "vpc" {
    source              = "../00_Module/vpc/"
    vpcs                = [
        {
            name_tag_postfix                        = "pub"
            identifier                              = "public"
            vpc_cidr                                = "192.168.1.0/24"
            attach_igw                              = true
            enable_dns_hostname                     = true
        },
        {

            name_tag_postfix                        = "pri"
            identifier                              = "private"
            vpc_cidr                                = "192.168.2.0/24"
            attach_igw                              = true
            enable_dns_hostname                     = true
        }
    ]
    subnets             = [
        {
            name_tag_postfix        = "pub-lb-a"
            identifier              = "pub-lb-a"
            vpc_identifier          = "public"
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.1.0/26"
            create_ngw              = false
        },
        {
            name_tag_postfix        = "pub-lb-a"
            identifier              = "pub-lb-c"
            vpc_identifier          = "public"
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.1.64/26"
            create_ngw              = false
        },
        {
            name_tag_postfix        = "pub-web-a"
            identifier              = "pub-web-a"
            vpc_identifier          = "public"
            availability_zone       = "ap-northeast-2a"
            cidr_block              = "192.168.1.128/26"
            create_ngw              = false
        },
        {
            name_tag_postfix        = "pub-web-c"
            identifier              = "pub-web-c"
            vpc_identifier          = "public"
            availability_zone       = "ap-northeast-2c"
            cidr_block              = "192.168.1.192/26"
            create_ngw              = false
        }
    ]
    rts                 = [
        {
            rt_identifier               = "pub-lb"
            vpc_identifier              = "public"
            name_tag_postfix            = "pub-lb"
        },
        {
            rt_identifier               = "pub-web"
            vpc_identifier              = "public"
            name_tag_postfix            = "pub-web"
        }
    ]
    rtps                = [
        {
            rt_identifier               = "pub-lb"
            rtp_identifier              = "igw"
            target_type                 = "gateway_id"
            target_identifier           = "public"
            destination_type            = "cidr_block"
            destination_address         = "0.0.0.0/0"
        }
    ]
    rtas                = [
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

module "vpc_flow_log" {
    source              = "../00_Module/vpc_flow_log/"
    vpc_flow_logs       =   [
        {
            vpc_id                      = module.vpc.vpc["public"].id
            log_destination             = data.terraform_remote_state.s3.outputs.s3_arn["s3-an2-tc01-dev"]
            log_destination_type        = "s3"
            traffic_type                = "ALL"
            max_aggregation_interval    = 60
        }
    ]
    name_tag_middle     = local.name_tag_middle
}