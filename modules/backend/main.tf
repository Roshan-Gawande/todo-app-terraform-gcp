resource "google_compute_instance" "backend" {
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
  }

  metadata_startup_script = templatefile("${path.module}/startup.sh", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
    repo_url    = var.repo_url
  })

  tags = ["backend", "todoapp"]
}
