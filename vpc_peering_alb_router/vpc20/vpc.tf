resource "aws_vpc" "vpc20" {
  cidr_block = "172.20.0.0/16"
  tags {
    Name = "vpc20"
  }
}

### ALL the subnets ###############################################
#public
resource "aws_subnet" "vpc20_public_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.0.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc20_public_us-east-1a"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc20_public_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.16.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc20_public_us-east-1b"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc20_public_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.32.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc20_public_us-east-1c"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc20_public_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.48.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc20_public_us-east-1d"
    Visibility = "public"
  }
}
#private subnets
resource "aws_subnet" "vpc20_private_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.64.0/20"
  tags {
    Name = "vpc20_private_us-east-1a"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc20_private_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.80.0/20"
  tags {
    Name = "vpc20_private_us-east-1b"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc20_private_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.96.0/20"
  tags {
    Name = "vpc20_private_us-east-1c"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc20_private_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.vpc20.id}"
  cidr_block = "172.20.112.0/20"
  tags {
    Name = "vpc20_private_us-east-1d"
    Visibility = "private"
  }
}

### IGW and NAT gateway to attach to routes ##################
resource "aws_internet_gateway" "servces_igw" {
  vpc_id = "${aws_vpc.vpc20.id}"
  tags {
    Name = "servces_igw"
  }
}

### Route tables #############################################
resource "aws_route_table" "vpc20_public" {
  vpc_id = "${aws_vpc.vpc20.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.servces_igw.id}"
  }
  tags {
    Name = "vpc20_public"
  }
}

resource "aws_route_table" "vpc20_private" {
  vpc_id = "${aws_vpc.vpc20.id}"
  tags {
    Name = "vpc20_private"
  }
}

### Route table associations ###################################
resource "aws_route_table_association" "public_us-east-1a" {
  route_table_id = "${aws_route_table.vpc20_public.id}"
  subnet_id = "${aws_subnet.vpc20_public_us-east-1a.id}"
}
resource "aws_route_table_association" "public_us-east-1b" {
  route_table_id = "${aws_route_table.vpc20_public.id}"
  subnet_id = "${aws_subnet.vpc20_public_us-east-1b.id}"
}
resource "aws_route_table_association" "public_us-east-1c" {
  route_table_id = "${aws_route_table.vpc20_public.id}"
  subnet_id = "${aws_subnet.vpc20_public_us-east-1c.id}"
}
resource "aws_route_table_association" "public_us-east-1d" {
  route_table_id = "${aws_route_table.vpc20_public.id}"
  subnet_id = "${aws_subnet.vpc20_public_us-east-1d.id}"
}
resource "aws_route_table_association" "private_us-east-1a" {
  route_table_id = "${aws_route_table.vpc20_private.id}"
  subnet_id = "${aws_subnet.vpc20_private_us-east-1a.id}"
}
resource "aws_route_table_association" "private_us-east-1b" {
  route_table_id = "${aws_route_table.vpc20_private.id}"
  subnet_id = "${aws_subnet.vpc20_private_us-east-1b.id}"
}
resource "aws_route_table_association" "private_us-east-1c" {
  route_table_id = "${aws_route_table.vpc20_private.id}"
  subnet_id = "${aws_subnet.vpc20_private_us-east-1c.id}"
}
resource "aws_route_table_association" "private_us-east-1d" {
  route_table_id = "${aws_route_table.vpc20_private.id}"
  subnet_id = "${aws_subnet.vpc20_private_us-east-1d.id}"
}
