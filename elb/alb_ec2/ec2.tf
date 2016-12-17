resource "aws_instance" "webserver_b" {
  ami = "ami-0ba2ac1c"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  tags {
    Name = "webserver"
  }
}
resource "aws_instance" "webserver_c" {
  ami = "ami-0ba2ac1c"
  instance_type = "t2.micro"
  availability_zone = "us-east-1c"
  tags {
    Name = "webserver"
  }
}
