# Grimoire

This is to track easily setting up an Attlassian Confluence stack with Terraforma and Ansible

##Prerequisites:

* Terraform
* Ansible

##Getting started

1. Perform a git clone of this repo.
1. Apply terraform configs (assuming that your working directory is the location of this file):
    ```
    terraform apply Terraform/
    ```
1. Use ansible to bring up the confluence stack:
    ```
    cd Ansible; ansible-playbook playbooks/confluence.yaml -i inventory
    ```
1. Log into the servers GUI over port 80
