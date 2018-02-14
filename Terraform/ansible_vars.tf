resource "local_file" "ansible_mysql_vars" {
    filename    = "${path.module}/../Ansible/roles/mysql/vars/main.yml"
    content     = <<VARS
{
    rds_endpoint: "${lookup(var.rds,"endpoint")}",
    rds_user: "${lookup(var.rds, "db_user")}",
    rds_password: "${lookup(var.rds, "db_passwd")}"
}
VARS
}

resource "local_file" "ansible_nginx_configs_vars" {
    filename    = "${path.module}/../Ansible/roles/nginx_configs/vars/main.yml"
    content     = <<VARS
{
    site_name: "${lookup(var.global,"site_name")}"
}
VARS
}

