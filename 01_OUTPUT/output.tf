output "Network" {
    value = data.terraform_remote_state.Network.outputs
}
output "Compute" {
    value = data.terraform_remote_state.Compute.outputs
}
output "SecurityGroup" {
    value = data.terraform_remote_state.SecurityGroup.outputs
}
output "ELB" {
    value = data.terraform_remote_state.ELB.outputs
}
output "s3_bucket" {
    value = data.terraform_remote_state.s3.outputs.s3_bucket
}
