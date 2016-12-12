variable "aws_route53_default_zoneid" {
  default = "ZEMD7XEJVSLN3"
}

provider "aws" {
  region = "us-east-1"
}

/*
data "aws_ami" "centos" {
  most_recent = true
  filter {
    name = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"] # Centos
}
*/

resource "aws_instance" "testinstance" {
    ami = "ami-6d1c2007"  #Centos
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-6e386a13","sg-72b7eb0f"] #default, ping_ssh
    key_name = "Laptop"
    associate_public_ip_address = true
    tags {
        Name = "TerraformTest"
        Environment = "Stage"
    }
}

resource "aws_route53_record" "testrecord" {
  zone_id = "${var.aws_route53_default_zoneid}"
  name = "terraformtest.dadams.io"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.web.public_ip}"]
}
