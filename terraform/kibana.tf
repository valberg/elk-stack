resource "aws_security_group" "kibana" {
  name   = "kibana"
  vpc_id = "${aws_vpc.elk_stack.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

data "aws_ami" "kibana" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^packer kibana .*"
}

resource "aws_instance" "kibana" {
  ami                    = "${data.aws_ami.kibana.id}"
  instance_type          = "t2.nano"
  vpc_security_group_ids = ["${aws_security_group.kibana.id}"]
  subnet_id              = "${aws_subnet.public.id}"

  tags = {
    Name = "Kibana"
  }
}
