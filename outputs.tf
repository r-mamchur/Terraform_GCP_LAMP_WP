
output "ip_static" {
  value = google_compute_address.vm_static_ip.address
}
output "ip_www" {
  value = google_compute_instance.vm_www.network_interface.0.access_config.0.nat_ip
}

output "ip_db" {
  value = google_compute_instance.vm_db.network_interface.0.access_config.0.nat_ip
}
