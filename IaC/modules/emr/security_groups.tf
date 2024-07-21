variable "vpc_id" {}

resource "aws_security_group" "master_security_group" {
  name        = "master_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id 

  revoke_rules_on_delete = true

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "worker_security_group" {
  name        = "worker_security_group"
  description = "Allow inbound traffic between instances"
  vpc_id      = var.vpc_id 

  revoke_rules_on_delete = true

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self = true
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }



}