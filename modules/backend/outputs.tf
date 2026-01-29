output "private_ip" {
  value = google_compute_instance.backend.network_interface[0].network_ip
}
