output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "public_subnet" {
  value = google_compute_subnetwork.public.id
}

output "private_subnet" {
  value = google_compute_subnetwork.private.id
}

output "private_ip_address" {
  value = google_compute_global_address.private_ip_address.address
}