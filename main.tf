provider "google" {
  credentials = file(var.credentials_file)
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_address" "vm_static_ip" {
  name = "www-static-ip"
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "ssh-firewall"
  network =  "terraform-network"
  depends_on = ["google_compute_network.vpc_network"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
    allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow-www" {
  name    = "www-firewall"
  network =  "terraform-network"
  depends_on = ["google_compute_network.vpc_network"]

  target_tags = ["web"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow-mysql" {
  name    = "mysql-firewall"
  network =  "terraform-network"
  depends_on = ["google_compute_network.vpc_network"]

  target_tags = ["mysql"]

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
}


