resource "google_sql_database_instance" "db" {
  name             = "app-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.vpc_id

      authorized_networks {
        name  = "allow-specified-network"
        value = var.authorized_network_ip
      }
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "todoapp" {
  name     = var.database_name
  instance = google_sql_database_instance.db.name
}

resource "google_sql_user" "todouser" {
  name     = var.database_user
  instance = google_sql_database_instance.db.name
  password = var.database_password
}
