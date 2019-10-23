
resource "google_compute_instance" "vm_db" {
  name         = "vm-db-mysql"
  machine_type = "f1-micro"
  tags         = ["mysql"]
  depends_on = ["google_compute_network.vpc_network"]

  metadata = {
   ssh-keys = "terr:${file(var.public_key_path)}"
  }
  boot_disk {
    initialize_params {
      image = "centos-7-v20191014"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_db.name}:  ${google_compute_instance.vm_db.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }
}
resource "null_resource" "prov_db" {
  depends_on = ["google_compute_instance.vm_db"]
  connection {
      type = "ssh"
      user = "terr"
      host =  "${google_compute_instance.vm_db.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file(var.private_key_path)}"
      agent = false   
  } 
  provisioner "file" {
    source      = "scenario_db.sh"
    destination = "~/scenario_db.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/scenario_db.sh",
      "sudo -E ~/scenario_db.sh",
    ]
  }
}

