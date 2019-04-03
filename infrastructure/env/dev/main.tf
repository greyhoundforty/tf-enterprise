data "ibm_compute_ssh_key" "deploymentKey" {
  label = "ryan_tycho"
}

resource "random_id" "name" {
  byte_length = 4
}

resource "ibm_compute_vm_instance" "node" {

  hostname                  = "tf-rt-${random_id.name.hex}"
  domain                    = "${var.domainname}"
  user_metadata             = "${file("install.yml")}"
  os_reference_code         = "${var.os["u16"]}"
  datacenter                = "${var.datacenter["us-east2"]}"
  network_speed             = 1000
  hourly_billing            = true
  private_network_only      = false
  flavor_key_name           = "${var.vm_flavor["medium"]}"
  disks                     = [200]
  local_disk                = false
  public_vlan_id            = "${var.pub_vlan["us-east2"]}"
  private_vlan_id           = "${var.priv_vlan["us-east2"]}"
  ssh_key_ids               = ["${data.ibm_compute_ssh_key.deploymentKey.id}"]

  tags = [
    "ryantiffany",
    "${format("%s-%03d", terraform.workspace ,count.index + 1)}"
  ]
}
