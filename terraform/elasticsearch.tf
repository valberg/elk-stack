resource "aws_security_group" "elasticsearch" {
  vpc_id = "${aws_vpc.elk_stack.id}"

  name = "elasticsearch"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

data "aws_ami" "elasticsearch" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^packer elasticsearch .*"
}

resource "aws_instance" "elasticsearch" {
  ami                    = "${data.aws_ami.elasticsearch.id}"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.elasticsearch.id}"]
  subnet_id              = "${aws_subnet.private.id}"
  private_ip             = "${var.elasticsearch_private_ip}"

  tags = {
    Name = "Elasticsearch"
  }
}
