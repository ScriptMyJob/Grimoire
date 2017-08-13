########################################
### Bastion Host Configs: ##############
########################################

resource "aws_key_pair" "grimoire_immutable" {
    key_name   = "rjackson"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCDHDITJ12qaNXesgjzYFQAXwSIj8K+lsHmyVmkov5n0+hV2JttKTo9zK7SfD9CruGOIhBeHZ15FjlFwReX7pqWSids7rkESiLYM/n/zDiZ18YRlXJVziK5IfataZ9n+1Q2PjaG1/eFIR6fmf2AJv2/3GG5CZnej/Ms5yPoVu790uBvYk9LL4EVUpB9YlbXIU1gLcwrlEh7XWSM/B2Lelk3n4XSUyemWlio5i2hvlUr98O6SNZbNVo6PLzdrp1gFbiwMqRdkZjNMbikizJfv3ocxmdlSZDiJc9adNlMnOBOEshvGvMRR7Uw+oNoaFktVaaVUjG68ExZFrKSGRT51b9z rjackson"
}

resource "aws_instance" "mysql_stack" {
    ami             = "ami-d15a75c7"
    instance_type   = "t2.micro"
    key_name        = "rjackson"
    tags {
        Name    = "MySQL Stack"
        Project = "grimoire_immutable"
    }
    vpc_security_group_ids      = [
        "${aws_security_group.ssh_inbound.id}",
        "${aws_security_group.mysql_inbound.id}"
    ]
    associate_public_ip_address = true
}

resource "aws_instance" "confluence_app_stack" {
    ami             = "ami-d15a75c7"
    instance_type   = "t2.small"
    key_name        = "rjackson"
    tags {
        Name    = "Confluence App Stack"
        Project = "grimoire_immutable"
    }
    vpc_security_group_ids      = [
        "${aws_security_group.ssh_inbound.id}",
        "${aws_security_group.web_inbound.id}",
        "${aws_security_group.from_conf_to_mysql.id}"
    ]
    associate_public_ip_address = true
}

resource "aws_eip" "mysql_ip" {}

resource "aws_eip" "confluence_ip" {}

resource "aws_eip_association" "mysql_ip"{
    instance_id     = "${aws_instance.mysql_stack.id}"
    allocation_id   = "${aws_eip.mysql_ip.id}"
}

resource "aws_eip_association" "confluence_ip" {
    instance_id     = "${aws_instance.confluence_app_stack.id}"
    allocation_id   = "${aws_eip.confluence_ip.id}"
}
