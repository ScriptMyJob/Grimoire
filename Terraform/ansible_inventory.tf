resource "local_file" "ansible_inventory" {
    filename    = "${path.module}/../Ansible/inventory"
    content     = <<INVENTORY
[aws]
confluence_16.04 ansible_ssh_host=${aws_eip.confluence_ip.public_ip}
database         ansible_ssh_host=${aws_eip.mysql_ip.public_ip}

[ubuntu]
confluence_16.04
database

[web_servers]
confluence_16.04

[db_servers]
database

[confluence]
confluence_16.04

[aws:vars]
ansible_ssh_private_key_file=${path.module}/../Resources/rjackson.pem

[ubuntu:vars]
ansible_ssh_user=ubuntu

INVENTORY
}
