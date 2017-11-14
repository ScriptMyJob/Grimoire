resource "aws_launch_configuration" "confluence_server" {
    name                            = "${lookup(var.ec2, "lc_name")}"
    image_id                        = "${lookup(var.ec2, "image")}"
    instance_type                   = "${lookup(var.ec2, "size")}"
    key_name                        = "${lookup(var.ec2, "key_name")}"
    security_groups                 = [
        "${aws_security_group.ssh_inbound.id}"
    ]
    associate_public_ip_address     = true
    user_data                       = "${lookup(var.ec2, "bootstrap")}"
    spot_price                      = "${lookup(var.ec2, "spot_price")}"
    iam_instance_profile            = "${aws_iam_role.associate_ip.id}"
}

resource "aws_autoscaling_group" "confluence_server" {
    depends_on                      = [
        "aws_launch_configuration.confluence_server"
    ]

    availability_zones              = [
        "us-west-2a",
        "us-west-2b",
        "us-west-2c"
    ]

    name                            = "${lookup(var.ec2, "asg_name")}"
    max_size                        = "${lookup(var.ec2, "max_size")}"
    min_size                        = "${lookup(var.ec2, "min_size")}"
    launch_configuration            = "${lookup(var.ec2, "lc_name")}"

    vpc_zone_identifier         = [
        "${aws_subnet.public_web_server_subnet_1.id}",
        "${aws_subnet.public_web_server_subnet_2.id}",
        "${aws_subnet.public_web_server_subnet_3.id}"
    ]

    tags    = [
        {
            key                     = "Name"
            value                   = "${lookup(var.ec2, "tag_name")}"
            propagate_at_launch     = true
        },
        {
            key                     = "Environment"
            value                   = "${lookup(var.global, "environment")}"
            propagate_at_launch     = true
        }
    ]
}
