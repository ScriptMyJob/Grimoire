#!/bin/bash
# Written by:   Robert J.
#               Robert@ScriptMyJob.com
set -e

main_function(){
    get_patches;
    get_python;
    get_awscli;
    associate_ip;
    get_nfs;
};

get_patches(){
    sudo apt-get update -y;
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y;
};

get_python(){
    sudo apt-get install python python-pip -y;
};

get_awscli(){
    sudo pip install awscli;
};

associate_ip(){
    ip='52.36.181.100'
    id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    aws ec2 associate-address \
        --public-ip "$ip" \
        --instance-id "$id" \
        --region 'us-west-2'
}

get_nfs(){
    sudo apt-get install nfs-common -y;
};

main_function;
