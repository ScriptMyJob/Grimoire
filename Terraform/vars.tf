########################################
### Variables ##########################
########################################

data "aws_availability_zones" "available" {}

variable "global" {
    type = "map"
    default = {
        environment = "Staging"
        region      = "us-west-2"
        site_name   = "grimoire.scriptmyjob.com"
    }
}

variable "ec2" {
    type = "map"
    default = {
        lc_name     = "Grimoire"
        asg_name    = "Confluence ASG"
        image       = "ami-0a00ce72"
        size        = "m3.medium"
        key_name    = "Grimoire"
        spot_price  = 0.07
        min_size    = 1
        max_size    = 1
        tag_name    = "Grimoire"
    }
}
