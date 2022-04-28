output "s3_bucket" {
    value = {for k,s3 in module.s3.s3 : k => s3.bucket }
}

output "s3_arn" {
    value = {for k,s3 in module.s3.s3 : k => s3.arn }
}