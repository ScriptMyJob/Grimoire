########################################
### Security Groups ####################
########################################

resource "aws_security_group" "ssh_inbound" {
    tags {
        Name = "DVOPS-464 - SSH from work and Terraform server"
    }
    ingress {
        cidr_blocks = [
            "${lookup(var.config, "trusted_network")}",
            "${lookup(var.config, "terraform_server")}"
        ]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }
}

resource "aws_security_group" "web_inbound" {
    tags {
        Name = "DVOPS-464 - Inbound Web services from anywhere"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }
}

resource "aws_security_group" "mysql_inbound" {
    tags {
        Name = "DVOPS-464 - Mysql Inbound"
    }
    ingress {
        cidr_blocks = [
            "${aws_eip.confluence_ip.public_ip}/32"
        ]
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
    }
}

resource "aws_security_group" "from_conf_to_mysql" {
    tags {
        Name = "DVOPS-464 - Confluence Outbound"
    }
    egress {
        cidr_blocks = [
            "${aws_eip.mysql_ip.public_ip}/32"
        ]
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
    }
}

