resource "local_file" "ansible_mysql_vars" {
    filename    = "${path.module}/../Ansible/roles/mysql/vars/main.yml"
    content     = <<VARS
{
    db_endpoint: "${lookup(var.db,"endpoint")}",
    db_user: "${lookup(var.db, "db_user")}",
    db_password: "${lookup(var.db, "db_passwd")}"
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

