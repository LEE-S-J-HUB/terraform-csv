output "ec2_instaces_id" {
    value = {for k,ec2 in module.create-ec2_instance.ec2_instance : k => ec2.id }
}