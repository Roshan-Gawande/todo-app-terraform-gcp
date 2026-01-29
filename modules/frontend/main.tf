resource "google_compute_instance" "frontend_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  metadata_startup_script = templatefile(
    "${path.module}/startup.sh",
    {
      backend_ip = var.backend_ip
      repo_url   = var.repo_url
    }
  )

  tags = ["frontend", "todoapp"]
}
