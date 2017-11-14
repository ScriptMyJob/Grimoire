########################################
### VPC Configs: #######################
########################################

resource "aws_vpc" "scriptmyjob_vpc" {
    cidr_block  = "${lookup(var.vpc,"vpc_cidr")}"

    tags {
        Name    = "${lookup(var.vpc,"vpc_name")}"
    }

    enable_dns_hostnames    = true
}

########################################
### Internet Gateways ##################
########################################

resource "aws_internet_gateway" "scriptmyjob_igw" {
    vpc_id = "${aws_vpc.scriptmyjob_vpc.id}"
    tags {
        Name = "scriptmyjob_igw"
    }
}

########################################
### Subnet Configs: ####################
########################################

resource "aws_subnet" "public_web_server_subnet_1" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"pub_ws_subnet_1")}"
    availability_zone   = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_1")}"
    }
}

resource "aws_subnet" "public_web_server_subnet_2" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"pub_ws_subnet_2")}"
    availability_zone   = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_1")}"
    }
}

resource "aws_subnet" "public_web_server_subnet_3" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"pub_ws_subnet_3")}"
    availability_zone   = "${data.aws_availability_zones.available.names[2]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_1")}"
    }
}

resource "aws_subnet" "master_web_server_1" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"priv_ws_subnet_1")}"
    availability_zone   = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_2")}"
    }
}

resource "aws_subnet" "master_web_server_2" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"priv_ws_subnet_2")}"
    availability_zone   = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_2")}"
    }
}

resource "aws_subnet" "master_web_server_3" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"priv_ws_subnet_3")}"
    availability_zone   = "${data.aws_availability_zones.available.names[2]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_2")}"
    }
}

resource "aws_subnet" "master_rds_1" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"rds_subnet_1")}"
    availability_zone   = "${data.aws_availability_zones.available.names[2]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_3")}"
    }
}

resource "aws_subnet" "master_rds_2" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"rds_subnet_2")}"
    availability_zone   = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "${lookup(var.vpc,"name_subnet_4")}"
    }
}

resource "aws_subnet" "efs_1" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"efs_subnet_1")}"
    availability_zone   = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "${lookup(var.efs,"name_1")}"
    }
}

resource "aws_subnet" "efs_2" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"efs_subnet_2")}"
    availability_zone   = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "${lookup(var.efs,"name_2")}"
    }
}

resource "aws_subnet" "efs_3" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"efs_subnet_3")}"
    availability_zone   = "${data.aws_availability_zones.available.names[2]}"
    tags {
        Name = "${lookup(var.efs,"name_3")}"
    }
}

resource "aws_subnet" "lambda_1" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"lambda_subnet_1")}"
    availability_zone   = "${data.aws_availability_zones.available.names[0]}"
    tags {
        Name = "${lookup(var.lambda,"name_1")}"
    }
}

resource "aws_subnet" "lambda_2" {
    vpc_id              = "${aws_vpc.scriptmyjob_vpc.id}"
    cidr_block          = "${lookup(var.vpc,"lambda_subnet_2")}"
    availability_zone   = "${data.aws_availability_zones.available.names[1]}"
    tags {
        Name = "${lookup(var.lambda,"name_2")}"
    }
}

########################################
### Route Tables #######################
########################################

# Private WS
####################

resource "aws_route_table" "private_web_server" {
    vpc_id = "${aws_vpc.scriptmyjob_vpc.id}"
    tags {
        Name        = "DFWHQ Route Table"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.scriptmyjob_igw.id}"
    }
}

# Public WS
####################

resource "aws_default_route_table" "public_web_server" {
    default_route_table_id = "${aws_vpc.scriptmyjob_vpc.default_route_table_id}"
    tags {
        Name        = "scriptmyjob Web Server Route Table"
    }
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.scriptmyjob_igw.id}"
    }
}

# Lambda Private Subnets
####################

resource "aws_route_table" "lambda" {
    vpc_id = "${aws_vpc.scriptmyjob_vpc.id}"
    tags {
        Name = "Private Routing Table for Lambda"
    }
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }
}

# EFS
####################

resource "aws_route_table_association" "efs_1" {
    subnet_id      = "${aws_subnet.efs_1.id}"
    route_table_id = "${aws_route_table.private_web_server.id}"
}

resource "aws_route_table_association" "efs_2" {
    subnet_id      = "${aws_subnet.efs_2.id}"
    route_table_id = "${aws_route_table.private_web_server.id}"
}

resource "aws_route_table_association" "efs_3" {
    subnet_id      = "${aws_subnet.efs_3.id}"
    route_table_id = "${aws_route_table.private_web_server.id}"
}

# Lambda
####################

resource "aws_route_table_association" "lambda_1" {
    subnet_id      = "${aws_subnet.lambda_1.id}"
    route_table_id = "${aws_route_table.lambda.id}"
}

resource "aws_route_table_association" "lambda_2" {
    subnet_id      = "${aws_subnet.lambda_2.id}"
    route_table_id = "${aws_route_table.lambda.id}"
}

########################################
### NAT Gateway ########################
########################################

# This is for the lambda function efs_backup
# Refer here if you have questions:
#     http://docs.aws.amazon.com/lambda/latest/dg/vpc.html#vpc-internet

resource "aws_eip" "nat_ip" {}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat_ip.id}"
    subnet_id     = "${aws_subnet.master_web_server_1.id}"
}

########################################
### Security Groups ####################
########################################

resource "aws_security_group" "web_inbound" {
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "VPC-1 - Inbound Web Services"
    tags {
        Name = "Inbound Web services from anywhere"
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
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "Mysql Inbound Wordpress"
    tags {
        Name        = "Mysql Inbound Wordpress"
    }
    ingress {
        cidr_blocks = [
            "${lookup(var.vpc,"eip_address")}/32"
        ]
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
    }
}

resource "aws_security_group" "ssh_inbound" {
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "SSH from trusted networks and Lambda"
    tags {
        Name        = "SSH from trusted networks and Lambda"
    }
    ingress {
        cidr_blocks = [
            "${var.trusted_hosts}",
            "${lookup(var.vpc,"lambda_subnet_1")}",
            "${lookup(var.vpc,"lambda_subnet_2")}"
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

resource "aws_security_group" "web_inbound_trusted" {
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "Inbound Web services from DFWHQ"
    tags {
        Name        = "Inbound Web services from DFWHQ"
    }
    ingress {
        cidr_blocks = ["${var.trusted_hosts}"]
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
    }
    ingress {
        cidr_blocks = ["${var.trusted_hosts}"]
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

resource "aws_security_group" "efs_mount" {
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "EFS Mount"
    tags {
        Name        = "EFS Mount"
    }
    egress {
        cidr_blocks = [
            "${lookup(var.vpc,"efs_subnet_1")}",
            "${lookup(var.vpc,"efs_subnet_2")}",
            "${lookup(var.vpc,"efs_subnet_3")}"
        ]
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
    }
}

resource "aws_security_group" "efs_service" {
    vpc_id          = "${aws_vpc.scriptmyjob_vpc.id}"
    name            = "EFS Service"
    tags {
        Name        = "EFS Service"
    }
    ingress {
        cidr_blocks = [
            "10.200.0.0/16"
        ]
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
    }
}
