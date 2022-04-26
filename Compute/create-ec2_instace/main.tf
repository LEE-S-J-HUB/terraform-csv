resource "aws_instance" "this" {
    for_each                      = { for ec2_instaces in var.ec2 : ec2_instaces.identifier => ec2_instaces }
    ami                           = each.value.ami
    instance_type                 = each.value.instance_type
    subnet_id                     = each.value.subnet_id
    availability_zone             = each.value.availability_zone
    vpc_security_group_ids        = each.value.vpc_security_group_ids
    user_data                     = each.value.user_data
    dynamic "root_block_device" {
        for_each                  = each.value.root_block_device
        iterator                  = root_block_device
        content {
            delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
            encrypted             = lookup(root_block_device.value, "encrypted", null)
            iops                  = lookup(root_block_device.value, "iops", null)
            kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
            volume_size           = lookup(root_block_device.value, "volume_size", null)
            volume_type           = lookup(root_block_device.value, "volume_type", null)
            throughput            = lookup(root_block_device.value, "throughput", null)
            tags                  = lookup(root_block_device.value, "tags", null)
        }
    }
    dynamic "launch_template" {
        for_each = each.value.launch_template.Existence == "yes" ? [each.value.launch_template] : []
        iterator = launch_template
        content {
            id      = lookup(launch_template.value, "id", null)
            name    = lookup(launch_template.value, "name", null)
            version = lookup(launch_template.value, "version", null)
        }
    }
    tags = {
        "Name" = "scg-${var.name_tag_middle}-${each.value.identifier}"
    }
}

resource "aws_eip" "eip" {
    for_each                    = { for eip in var.eips : eip.identifier => eip }
    vpc                         = true
    instance                    = aws_instance.this["${each.value.ec2_identifier}"].id
    associate_with_private_ip   = aws_instance.this["${each.value.ec2_identifier}"].private_ip
    tags                        = {
        "Name" = "eip-${var.name_tag_middle}-${each.value.ec2_identifier}"
    }
}