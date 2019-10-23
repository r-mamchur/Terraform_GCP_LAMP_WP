resource "google_compute_instance" "vm_www" {
  name         = "vm-www"
  machine_type = "f1-micro"
  tags         = ["web", "wordpress"]
  depends_on = ["google_compute_address.vm_static_ip", "google_compute_network.vpc_network"]

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
       nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}
resource "null_resource" "prov_wp_conf" {
  depends_on = ["google_compute_instance.vm_www"]
  connection {
      type = "ssh"
      user = "terr"
      host =  "${google_compute_instance.vm_www.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file(var.private_key_path)}"
      agent = false   
  } 
  provisioner "file" {
    source      = "./wp-config.php"
    destination = "/tmp/wp-config.php" 
  }
}
resource "null_resource" "prov_www" {
  depends_on = ["google_compute_instance.vm_www", "null_resource.prov_wp_conf"]
  connection {
      type = "ssh"
      user = "terr"
      host =  "${google_compute_instance.vm_www.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file(var.private_key_path)}"
      agent = false   
  } 
  provisioner "file" {
    source      = "scenario_www.sh"
    destination = "~/scenario_www.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/scenario_www.sh",
      "sudo -E ~/scenario_www.sh",
    ]
  }
}
