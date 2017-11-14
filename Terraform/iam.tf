########################################
### IAM Policy Documents ###############
########################################

data "aws_iam_policy_document" "associate_ip" {
    statement {
        effect = "Allow"
        actions = [
            "ec2:AssociateAddress"
        ]
        resources = [
            "*"
        ]
    }
}

########################################
### IAM Policies #######################
########################################

resource "aws_iam_policy" "associate_ip" {
    name    = "AssociateIP"
    policy  = "${data.aws_iam_policy_document.associate_ip.json}"
}

########################################
### IAM Roles ##########################
########################################

resource "aws_iam_role" "associate_ip" {
    name = "AssociateIP"
    assume_role_policy = "${lookup(var.ec2,"policy")}"
}

########################################
### IAM Policy Attachments #############
########################################

resource "aws_iam_policy_attachment" "associate_ip" {
    name            = "AssociateIP"
    roles           = [
        "${aws_iam_role.associate_ip.name}"
    ]
    policy_arn      = "${aws_iam_policy.associate_ip.arn}"
}
