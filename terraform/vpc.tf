resource "aws_vpc" "elk_stack" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.elk_stack.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.elk_stack.id}"
  cidr_block = "${var.private_subnet_cidr}"

  tags = {
    Name = "Private"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.elk_stack.id}"
}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"
  depends_on    = ["aws_internet_gateway.default"]
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.elk_stack.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.elk_stack.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }

  tags = {
    Name = "Private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}
