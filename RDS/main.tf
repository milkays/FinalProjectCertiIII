locals {
    subnet_ids   = data.aws_ssm_parameters_by_path.vpc_subnets.values
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = data.aws_ssm_parameters_by_path.vpc_subnets.values
}

# resource "aws_security_group" "rds-sg" {
#   name   = "my-rds-sg"
#   vpc_id = data.aws_ssm_parameter.vpc_id_parameter.value

# }

# Ingress Security Port 3306
# resource "aws_security_group_rule" "mysql_inbound_access" {
#   from_port         = 3306
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.rds-sg.id}"
#   to_port           = 3306
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }
# resource "aws_db_instance" "upb_project" {
#   allocated_storage           = 20
#   storage_type                = "gp2"
#   engine                      = "mysql"
#   engine_version              = "5.7"
#   instance_class              = "db.t3.micro"
#   name                        = "db_mysql"
#   username                    = "admin"
#   password                    = "admin123"
#   parameter_group_name        = "default.mysql5.7"
#   db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet.name}"
#   vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
#   allow_major_version_upgrade = true
#   auto_minor_version_upgrade  = true
#   backup_retention_period     = 35
#   backup_window               = "22:00-23:00"
#   maintenance_window          = "Sat:00:00-Sat:03:00"
#   multi_az                    = true
#   skip_final_snapshot         = true
# }
resource "aws_security_group" "rds-sg" {
  name   = "sg_rds"
  vpc_id = data.aws_ssm_parameter.vpc_id_parameter.value

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_rds"
  }
}
resource "aws_db_instance" "rds_mysql" {
  identifier             = "rdsmysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "admin"
  password               = "admin123"
  db_subnet_group_name   = "${aws_db_subnet_group.rds-private-subnet.name}"
  vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = true
  skip_final_snapshot    = true
}