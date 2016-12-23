#allow service to talk with ALB
resource "aws_iam_role" "ecs_service" {
  name = "ecsServiceRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17", 
  "Statement": [
    {
     "Action": "sts:AssumeRole", 
      "Principal": {
        "Service": "ecs.amazonaws.com"
      }, 
      "Effect": "Allow", 
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs_service_attachment" {
  role = "${aws_iam_role.ecs_service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


#allow instances to talk with scheduler
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "ecs_instance"
  roles = ["${aws_iam_role.ecs_instance.name}"]
}
resource "aws_iam_role" "ecs_instance" {
  name = "ecsInstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17", 
  "Statement": [
    {
     "Action": "sts:AssumeRole", 
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Effect": "Allow", 
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs_instance_attachment" {
  role = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
