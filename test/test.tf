provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "digitalocean_droplet" "testdroplet" {
  image = "centos-7-x64"
  name = "terraformtest.dadams.io"
  region = "nyc1"
  size = "512mb"
  ssh_keys = [1600751]
  ipv6 = "true"
}

# v4 record
resource "cloudflare_record" "testrecord_v4" {
  domain = "dadams.io"
  name = "terraformtest"
  type = "A"
  value = "${digitalocean_droplet.testdroplet.ipv4_address}"
}
# v6 record
resource "cloudflare_record" "testrecord_v6" {
  domain = "dadams.io"
  name = "terraformtest"
  type = "AAAA"
  value = "${digitalocean_droplet.testdroplet.ipv6_address}"
