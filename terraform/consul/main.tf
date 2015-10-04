variable "count" {
  default = 3
}

resource "openstack_compute_servergroup_v2" "consul" {
  name = "consul"
  policies = ["anti-affinity"]
}

resource "openstack_compute_instance_v2" "consul" {
  count = "${var.count}"
  name = "${format("consul-%02d", count.index+1)}"
  image_name = "Ubuntu 14.04"
  flavor_name = "m1.small"
  key_pair = "infra"
  security_groups = ["AllowAll"]
  config_drive = true
  user_data = "${file("scripts/bootstrap.sh")}"
  scheduler_hints {
    group = "${openstack_compute_servergroup_v2.consul.id}"
  }

  provisioner "local-exec" {
    command = "sed -i -e '/${self.name}/d' ~/infrastructure/nodes && echo ${self.name} ${self.access_ip_v6} consul >> ~/infrastructure/nodes"
  }
}

resource "aws_route53_record" "consul-v6" {
  zone_id = "CHANGEME"
  name = "consul.example.com"
  type = "AAAA"
  ttl = "60"
  records = ["${replace(openstack_compute_instance_v2.consul.*.access_ip_v6, "/[\[\]]/", "")}"]
}

resource "aws_route53_record" "consul-txt" {
  zone_id = "CHANGEME"
  name = "consul.example.com"
  type = "TXT"
  ttl = "60"
  records = ["${formatlist("%s.example.com", openstack_compute_instance_v2.consul.*.name)}"]
}

resource "aws_route53_record" "consul-individual" {
  count = "${var.count}"

  zone_id = "CHANGEME"
  name = "${format("consul-%02d.example.com", count.index+1)}"
  type = "AAAA"
  ttl = "60"
  records = ["${replace(element(openstack_compute_instance_v2.consul.*.access_ip_v6, count.index), "/[\[\]]/", "")}"]
}

resource "null_resource" "consul" {
  count = "${var.count}"

  provisioner "local-exec" {
    command = "sleep 10 && cd ~/infrastructure && make waffles NODE=${element(aws_route53_record.consul-individual.*.name, count.index)} KEY=keys/infra ROLE=consul"
  }
}
