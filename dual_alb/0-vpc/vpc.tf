resource "aws_vpc" "services" {
  cidr_block = "172.17.0.0/16"
  tags {
    Name = "services"
  }
}

### ALL the subnets ###############################################
#public
resource "aws_subnet" "services_public_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.0.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "services_public_us-east-1a"
    Visibility = "public"
  }
}
resource "aws_subnet" "services_public_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.1.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "services_public_us-east-1b"
    Visibility = "public"
  }
}
resource "aws_subnet" "services_public_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.2.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "services_public_us-east-1c"
    Visibility = "public"
  }
}
resource "aws_subnet" "services_public_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.3.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "services_public_us-east-1d"
    Visibility = "public"
  }
}
#private subnets
resource "aws_subnet" "services_private_us-east-1a" {
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.16.0/24"
  tags {
    Name = "services_private_us-east-1a"
    Visibility = "private"
  }
}
resource "aws_subnet" "services_private_us-east-1b" {
  availability_zone = "us-east-1b"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.17.0/24"
  tags {
    Name = "services_private_us-east-1b"
    Visibility = "private"
  }
}
resource "aws_subnet" "services_private_us-east-1c" {
  availability_zone = "us-east-1c"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.18.0/24"
  tags {
    Name = "services_private_us-east-1c"
    Visibility = "private"
  }
}
resource "aws_subnet" "services_private_us-east-1d" {
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.services.id}"
  cidr_block = "172.17.19.0/24"
  tags {
    Name = "services_private_us-east-1d"
    Visibility = "private"
  }
}

### IGW and NAT gateway to attach to routes ##################
resource "aws_internet_gateway" "servces_igw" {
  vpc_id = "${aws_vpc.services.id}"
  tags {
    Name = "servces_igw"
  }
}
#costs $$
resource "aws_nat_gateway" "services_nat" {
  allocation_id = "${aws_eip.nat_gateway_eip.id}"
  subnet_id = "${aws_subnet.services_public_us-east-1a.id}"
  depends_on = ["aws_internet_gateway.servces_igw"]
}
resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

### Route tables #############################################
resource "aws_route_table" "services_public" {
  vpc_id = "${aws_vpc.services.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.servces_igw.id}"
  }
  tags {
    Name = "services_public"
  }
}

resource "aws_route_table" "services_private" {
  vpc_id = "${aws_vpc.services.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.services_nat.id}"
  }
  tags {
    Name = "services_private"
  }
}

### Route table associations ###################################
resource "aws_route_table_association" "public_us-east-1a" {
  route_table_id = "${aws_route_table.services_public.id}"
  subnet_id = "${aws_subnet.services_public_us-east-1a.id}"
}
resource "aws_route_table_association" "public_us-east-1b" {
  route_table_id = "${aws_route_table.services_public.id}"
  subnet_id = "${aws_subnet.services_public_us-east-1b.id}"
}
resource "aws_route_table_association" "public_us-east-1c" {
  route_table_id = "${aws_route_table.services_public.id}"
  subnet_id = "${aws_subnet.services_public_us-east-1c.id}"
}
resource "aws_route_table_association" "public_us-east-1d" {
  route_table_id = "${aws_route_table.services_public.id}"
  subnet_id = "${aws_subnet.services_public_us-east-1d.id}"
}
resource "aws_route_table_association" "private_us-east-1a" {
  route_table_id = "${aws_route_table.services_private.id}"
  subnet_id = "${aws_subnet.services_private_us-east-1a.id}"
}
resource "aws_route_table_association" "private_us-east-1b" {
  route_table_id = "${aws_route_table.services_private.id}"
  subnet_id = "${aws_subnet.services_private_us-east-1b.id}"
}
resource "aws_route_table_association" "private_us-east-1c" {
  route_table_id = "${aws_route_table.services_private.id}"
  subnet_id = "${aws_subnet.services_private_us-east-1c.id}"
}
resource "aws_route_table_association" "private_us-east-1d" {
  route_table_id = "${aws_route_table.services_private.id}"
  subnet_id = "${aws_subnet.services_private_us-east-1d.id}"
}
