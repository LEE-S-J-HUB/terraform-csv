locals {
    name_tag_middle = "an2-tc01-dev"
}

module "s3" {
    source = "../00_Module/s3/"
    s3s     = [
        {
            bucket                      = "s3-${local.name_tag_middle}"
            force_destroy               = false
            kms_master_key_id           = "arn:aws:kms:ap-northeast-2:304149346685:key/7ee9bc2b-bd3e-430a-af40-2501692a1fef"
            sse_algorithm               = "aws:kms"
            block_public_acls           = true
            block_public_policy         = true
            ignore_public_acls          = true
            restrict_public_buckets     = true
            s3_bucket_versioning        = "Disabled"
        }
    ]
    name_tag_middle                     = local.name_tag_middle
}