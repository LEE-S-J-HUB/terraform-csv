resource "aws_s3_bucket" "this" {
    for_each                    = { for s3 in var.s3s : s3.bucket => s3 if s3.bucket != null}
    bucket                      = "${each.value.bucket}"
    force_destroy               = each.value.force_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
    for_each                    = { for s3 in var.s3s : s3.bucket => s3 if s3.kms_master_key_id != null}
    bucket                      = aws_s3_bucket.this["${each.value.bucket}"].bucket
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id       = "arn:aws:kms:ap-northeast-2:304149346685:key/7ee9bc2b-bd3e-430a-af40-2501692a1fef"
        sse_algorithm           = "aws:kms"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
    for_each                    = { for s3 in var.s3s : s3.bucket => s3 if s3.bucket != null}
    bucket                      = aws_s3_bucket.this["${each.value.bucket}"].bucket
    block_public_acls           = each.value.block_public_acls
    block_public_policy         = each.value.block_public_policy
    ignore_public_acls          = each.value.ignore_public_acls
    restrict_public_buckets     = each.value.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "this" {
    for_each                    = { for s3 in var.s3s : s3.bucket => s3 if s3.bucket != null}
    bucket                      = aws_s3_bucket.this["${each.value.bucket}"].bucket
    versioning_configuration {
        status      = "${each.value.s3_bucket_versioning}"
    }
}