locals {
    name_tag_middle         = "an2-tc01-dev"
    kms_ebs_dev             = "arn:aws:kms:ap-northeast-2:304149346685:key/50b78494-f91d-4dff-af74-a9d01eefc5b2"
    # kms key arn으로 작성 필요
    ec2_default_user_data   = <<EOF
#cloud-config
system_info:
  default_user:
    name: sysadmin
    gecos: sysadmin
    uid: "1020"

ssh_pwauth: true

chpasswd:
  expire: true

chpasswd:
  list:
    - sysadmin:sysadmin

package_update: true
package_upgrade: true
packages:
 - awscli
 - nvme-cli

ntp:
  enabled: true
  ntp_client: chrony
  servers:
    - 169.254.169.123

timezone: ROK
#timezone: Asia/Seoul

runcmd:
  - [ sed, -i, 's/#Port 22/Port 10022/g', /etc/ssh/sshd_config ]
  - [ systemctl, restart, sshd ]
  - [ sed, -i, 's/name: ec2-user/name: sysadmin/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/lock_passwd: true/lock_passwd: false/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/gecos: EC2 Default User/gecos: sysadmin/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/ssh_pwauth:   false/ssh_pwauth:   true/g', /etc/cloud/cloud.cfg ]

hostname: test
manage_etc_hosts: true

output:
    init:
        output: "> /var/log/cloud-init.out"
        error: "> /var/log/cloud-init.err"
    config: "tee -a /var/log/cloud-config.log"
    final:
        - ">> /var/log/cloud-final.out"
        - "/var/log/cloud-final.err"
EOF
}

module "create-ec2_instance" {
    source = "../00_Module/ec2"
    ec2 = [
        {
            identifier              = "bestion"
            ami                     = "ami-02de72c5dc79358c9"
            instance_type           = "t2.micro"
            availability_zone       = "ap-northeast-2a"
            subnet_id               =  data.terraform_remote_state.Network.outputs.sub_id["pub-lb-a"]
            vpc_security_group_ids  = ["${data.terraform_remote_state.Security_Group.outputs.security_group_id["bestion"]}"]
            user_data               = "${local.ec2_default_user_data}"
            root_block_device = [
                {
                    volume_type             = "gp2"
                    volume_size             = 50
                    delete_on_termination   = true
                    encrypted               = true
                    kms_key_id              = "${local.kms_ebs_dev}"
                    tags = {
                        Name = "ebs-${local.name_tag_middle}-bestion"
                    }
                }
            ]
            launch_template = {
                Existence = "no"
            }
        },
        {
            identifier              = "web"
            ami                     = "ami-02de72c5dc79358c9"
            instance_type           = "t2.micro"
            availability_zone       = "ap-northeast-2a"
            subnet_id               =  data.terraform_remote_state.Network.outputs.sub_id["pub-web-a"]
            vpc_security_group_ids  = ["${data.terraform_remote_state.Security_Group.outputs.security_group_id["web"]}"]
            user_data               = "${local.ec2_default_user_data}"
            root_block_device = [
                {
                    volume_type             = "gp2"
                    volume_size             = 50
                    delete_on_termination   = true
                    encrypted               = true
                    kms_key_id              = "${local.kms_ebs_dev}"
                    tags = {
                        Name = "ebs-${local.name_tag_middle}-web"
                    }
                }
            ]
            launch_template = {
                Existence = "no"
            }
        }
    ]
    eips        = [
        {
            identifier      = "bestion"
            ec2_identifier  = "bestion"
        }
    ]
	name_tag_middle = local.name_tag_middle
}