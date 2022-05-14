locals {
    db_username = "admin"
    db_password = "administrador"
    
    
    db_name = "smdb"
    
    sm_vpc_id = data.aws_ssm_parameter.vpc_id_parameter.value
    sm_vpc_db_subnets = data.aws_ssm_parameters_by_path.vpc_subnets.values
   }

resource "aws_security_group" "sm_sg" {
  name        = "sm-sg"
  vpc_id      = local.sm_vpc_id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sm-sg"
  }
}

resource "aws_db_subnet_group" "sm_db_subnet_group" {
  name       = "sm-db-subnet-group"
  subnet_ids = local.sm_vpc_db_subnets

  tags = {
    Name = "Secrets manager subnet group"
  }
}

resource "aws_db_instance" "sm_database" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = local.db_username
  password             = local.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  
  db_name               = local.db_name
  apply_immediately     = true
  port                  = 3306
  vpc_security_group_ids = [aws_security_group.sm_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.sm_db_subnet_group.id
}
resource "aws_secretsmanager_secret" "secretEC2" {
   name = "EC2Secret"
}
 
# Creating a AWS secret versions for database master account (Masteraccoundb)
 
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretEC2.id
  secret_string = <<EOF
   {
    "key": "AKIA6LZDI4XDKZWHKNWN",
    "key_id": "hy2mSIfd6ZGKsA9n7735gNXPxkqvInoLH/OxLJa9",
    "keyPair": "MyKeyPair.pem" ,
    "ec2_link": "ec2-user@ec2-44-199-252-224.compute-1.amazonaws.com"
   }
EOF
}
