variable "name_tag_middle" {
    type        = string
}

variable "s3s" {
    type = list(object({
        bucket                      = string
        force_destroy               = bool
        kms_master_key_id           = string
        sse_algorithm               = string
        block_public_acls           = bool
        block_public_policy         = bool
        ignore_public_acls          = bool
        restrict_public_buckets     = bool    
        s3_bucket_versioning        = string 
        object_ownership            = string
    }))
}