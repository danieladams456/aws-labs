resource "aws_vpc_peering_connection" "18transit_to_19" {
  peer_vpc_id = "${data.terraform_remote_state.vpc19.vpc_id}"
  vpc_id = "${data.terraform_remote_state.vpc18transit.vpc_id}"
  auto_accept = true
}

resource "aws_vpc_peering_connection" "18transit_to_20" {
  peer_vpc_id = "${data.terraform_remote_state.vpc20.vpc_id}"
  vpc_id = "${data.terraform_remote_state.vpc18transit.vpc_id}"
  auto_accept = true
}


####  Route table additions  ###################################
# VPCs 18 and 19
resource "aws_route" "18transit_public_to_19" {
  route_table_id = "${data.terraform_remote_state.vpc18transit.route_table_public}"
  destination_cidr_block = "${data.terraform_remote_state.vpc19.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_19.id}"
}
resource "aws_route" "18transit_private_to_19" {
  route_table_id = "${data.terraform_remote_state.vpc18transit.route_table_private}"
  destination_cidr_block = "${data.terraform_remote_state.vpc19.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_19.id}"
}
resource "aws_route" "19_public_to_18transit" {
  route_table_id = "${data.terraform_remote_state.vpc19.route_table_public}"
  destination_cidr_block = "${data.terraform_remote_state.vpc18transit.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_19.id}"
}
resource "aws_route" "19_private_to_18transit" {
  route_table_id = "${data.terraform_remote_state.vpc19.route_table_private}"
  destination_cidr_block = "${data.terraform_remote_state.vpc18transit.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_19.id}"
}

# VPCs 18 and 20
resource "aws_route" "18transit_public_to_20" {
  route_table_id = "${data.terraform_remote_state.vpc18transit.route_table_public}"
  destination_cidr_block = "${data.terraform_remote_state.vpc20.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_20.id}"
}
resource "aws_route" "18transit_private_to_20" {
  route_table_id = "${data.terraform_remote_state.vpc18transit.route_table_private}"
  destination_cidr_block = "${data.terraform_remote_state.vpc20.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_20.id}"
}
resource "aws_route" "20_public_to_18transit" {
  route_table_id = "${data.terraform_remote_state.vpc20.route_table_public}"
  destination_cidr_block = "${data.terraform_remote_state.vpc18transit.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_20.id}"
}
resource "aws_route" "20_private_to_18transit" {
  route_table_id = "${data.terraform_remote_state.vpc20.route_table_private}"
  destination_cidr_block = "${data.terraform_remote_state.vpc18transit.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.18transit_to_20.id}"
}
