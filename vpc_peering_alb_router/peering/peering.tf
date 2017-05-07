resource "aws_vpc_peering_connection" "18transit_to_19" {
  // peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id = "${data.terraform_remote_state.vpc19.vpc_id}"
  vpc_id = "${data.terraform_remote_state.vpc18transit.vpc_id}"
  auto_accept = true
  //
  // accepter {
  //   allow_remote_vpc_dns_resolution = true
  // }
  //
  // requester {
  //   allow_remote_vpc_dns_resolution = true
  // }
}

resource "aws_vpc_peering_connection" "18transit_to_20" {
  // peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id = "${data.terraform_remote_state.vpc20.vpc_id}"
  vpc_id = "${data.terraform_remote_state.vpc18transit.vpc_id}"
  auto_accept = true
  //
  // accepter {
  //   allow_remote_vpc_dns_resolution = true
  // }
  //
  // requester {
  //   allow_remote_vpc_dns_resolution = true
  // }
}
