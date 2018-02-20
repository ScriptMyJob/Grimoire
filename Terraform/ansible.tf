resource "null_resource" "ansible_exec" {
    depends_on =[
        "aws_autoscaling_group.confluence_server"
    ]

    provisioner "local-exec" {
        command     = " "
        interpreter = ["/bin/bash", "./local-exec-ansible.sh"]
    }
}
