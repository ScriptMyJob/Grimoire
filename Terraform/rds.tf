########################################
### RDS Instance #######################
########################################

resource "aws_rds_cluster" "scriptmyjob_shared_db" {

    # FIX for IGW_2 not destorying on `terraform destroy`
    depends_on                      = [
        "aws_internet_gateway.scriptmyjob_igw"
    ]

    database_name                   = "${lookup(var.rds, "db_name")}"
    master_username                 = "${lookup(var.rds, "db_user")}"
    master_password                 = "${lookup(var.rds, "db_password")}"
    port                            = "${lookup(var.rds, "db_port")}"
    vpc_security_group_ids          = [
        "${aws_security_group.mysql_inbound.id}"
    ]
    db_subnet_group_name            = "${aws_db_subnet_group.default.name}"
    cluster_identifier              = "${lookup(var.rds, "db_identifier_cluster")}"
    db_cluster_parameter_group_name = "${lookup(var.rds, "db_type")}"
    backup_retention_period         = "${lookup(var.rds, "db_backup_retention")}"
    preferred_backup_window         = "${lookup(var.rds, "db_backup_window")}"
    preferred_maintenance_window    = "${lookup(var.rds, "db_maint_window")}"
    storage_encrypted               = "${lookup(var.rds, "db_encryption")}"
    skip_final_snapshot             = true
    # final_snapshot_identifier       = "${lookup(var.rds, "db_final_snap")}"
}

resource "aws_rds_cluster_instance" "scriptmyjob_shared_db" {
    depends_on                      = ["aws_rds_cluster.scriptmyjob_shared_db"]
    count                           = "${lookup(var.rds, "db_count")}"
    identifier                      = "${lookup(var.rds, "db_identifier")}"
    cluster_identifier              = "${lookup(var.rds, "db_identifier_cluster")}"
    instance_class                  = "${lookup(var.rds, "db_instance_type")}"
}

resource "aws_db_subnet_group" "default" {
    name                            = "main"
    subnet_ids                      = [
        "${aws_subnet.master_rds_1.id}",
        "${aws_subnet.master_rds_2.id}"
    ]
}

