resource "aws_security_group" "logstash" {
  vpc_id = "${aws_vpc.elk_stack.id}"

  name = "logstash"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

data "aws_ami" "logstash" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^packer logstash .*"
}

resource "aws_instance" "logstash" {
  ami                    = "${data.aws_ami.logstash.id}"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.logstash.id}"]
  subnet_id              = "${aws_subnet.private.id}"
  private_ip             = "${var.logstash_private_ip}"

  tags = {
    Name = "Logstash"
  }
}
