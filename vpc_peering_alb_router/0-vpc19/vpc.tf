resource "aws_vpc" "vpc19" {
  cidr_block = "172.19.0.0/16"
  tags {
    Name = "vpc19"
  }
}

### ALL the subnets ###############################################
#public
resource "aws_subnet" "vpc19_public_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.0.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc19_public_us-east-1a"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc19_public_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.16.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc19_public_us-east-1b"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc19_public_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.32.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc19_public_us-east-1c"
    Visibility = "public"
  }
}
resource "aws_subnet" "vpc19_public_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.48.0/20"
  map_public_ip_on_launch = true
  tags {
    Name = "vpc19_public_us-east-1d"
    Visibility = "public"
  }
}
#private subnets
resource "aws_subnet" "vpc19_private_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.64.0/20"
  tags {
    Name = "vpc19_private_us-east-1a"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc19_private_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.80.0/20"
  tags {
    Name = "vpc19_private_us-east-1b"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc19_private_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.96.0/20"
  tags {
    Name = "vpc19_private_us-east-1c"
    Visibility = "private"
  }
}
resource "aws_subnet" "vpc19_private_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.vpc19.id}"
  cidr_block = "172.19.112.0/20"
  tags {
    Name = "vpc19_private_us-east-1d"
    Visibility = "private"
  }
}

### IGW and NAT gateway to attach to routes ##################
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc19.id}"
  tags {
    Name = "igw"
  }
}

### Route tables #############################################
resource "aws_route_table" "vpc19_public" {
  vpc_id = "${aws_vpc.vpc19.id}"
  tags {
    Name = "vpc19_public"
  }
}
resource "aws_route_table" "vpc19_private" {
  vpc_id = "${aws_vpc.vpc19.id}"
  tags {
    Name = "vpc19_private"
  }
}

### Routes #####################################################
resource "aws_route" "vpc19_public_default" {
  route_table_id = "${aws_route_table.vpc19_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

### Route table associations ###################################
resource "aws_route_table_association" "public_us-east-1a" {
  route_table_id = "${aws_route_table.vpc19_public.id}"
  subnet_id = "${aws_subnet.vpc19_public_us-east-1a.id}"
}
resource "aws_route_table_association" "public_us-east-1b" {
  route_table_id = "${aws_route_table.vpc19_public.id}"
  subnet_id = "${aws_subnet.vpc19_public_us-east-1b.id}"
}
resource "aws_route_table_association" "public_us-east-1c" {
  route_table_id = "${aws_route_table.vpc19_public.id}"
  subnet_id = "${aws_subnet.vpc19_public_us-east-1c.id}"
}
resource "aws_route_table_association" "public_us-east-1d" {
  route_table_id = "${aws_route_table.vpc19_public.id}"
  subnet_id = "${aws_subnet.vpc19_public_us-east-1d.id}"
}
resource "aws_route_table_association" "private_us-east-1a" {
  route_table_id = "${aws_route_table.vpc19_private.id}"
  subnet_id = "${aws_subnet.vpc19_private_us-east-1a.id}"
}
resource "aws_route_table_association" "private_us-east-1b" {
  route_table_id = "${aws_route_table.vpc19_private.id}"
  subnet_id = "${aws_subnet.vpc19_private_us-east-1b.id}"
}
resource "aws_route_table_association" "private_us-east-1c" {
  route_table_id = "${aws_route_table.vpc19_private.id}"
  subnet_id = "${aws_subnet.vpc19_private_us-east-1c.id}"
}
resource "aws_route_table_association" "private_us-east-1d" {
  route_table_id = "${aws_route_table.vpc19_private.id}"
  subnet_id = "${aws_subnet.vpc19_private_us-east-1d.id}"
}
