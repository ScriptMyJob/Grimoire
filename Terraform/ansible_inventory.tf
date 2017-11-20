resource "local_file" "ansible_inventory" {
    filename    = "${path.module}/../Ansible/inventory"
    content     = <<INVENTORY
[aws]
confluence_16.04 ansible_ssh_host=${var.eip_address}

[ubuntu]
confluence_16.04

[web_servers]
confluence_16.04

[db_servers]

[confluence]
confluence_16.04

[aws:vars]
ansible_ssh_private_key_file='~/.ssh/AWS/Grimoire.pem'

[ubuntu:vars]
ansible_ssh_user=ubuntu

INVENTORY
}

resource "null_resource" "chmod" {
    depends_on      = ["local_file.ansible_inventory"]
    provisioner "local-exec" {
        command     = "chmod 600 ${path.module}/../Ansible/inventory"
    }
}
