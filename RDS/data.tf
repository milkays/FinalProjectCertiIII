data "aws_ssm_parameter" "vpc_id_parameter" { # data.aws_ssm_parameter.vpc_id_parameter.value
  name = "/vpc/id"
}
data "aws_ssm_parameters_by_path" "vpc_subnets" {
  path = "/vpc/subnets/db"
}