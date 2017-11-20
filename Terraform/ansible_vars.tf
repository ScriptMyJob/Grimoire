resource "local_file" "ansible_mysql_vars" {
    filename    = "${path.module}/../Ansible/roles/mysql/vars/main.yml"
    content     = <<VARS
{
    rds_endpoint: "${aws_rds_cluster.scriptmyjob_shared_db.endpoint}",
    rds_user: "${lookup(var.rds, "db_user")}",
    rds_password: "${lookup(var.rds, "db_password")}"
}
VARS
}
