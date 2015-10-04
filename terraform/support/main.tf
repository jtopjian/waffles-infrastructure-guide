resource "openstack_compute_keypair_v2" "support" {
  name = "infra"
  public_key = "${file("~/infrastructure/keys/infra.pub")}"
}

resource "openstack_compute_secgroup_v2" "support" {
  name = "AllowAll"
  description = "Rule to allow all traffic"

  rule {
    ip_protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr = "::/0"
  }

  rule {
    ip_protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr = "::/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr = "::/0"
  }
}
